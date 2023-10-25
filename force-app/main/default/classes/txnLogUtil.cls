public with sharing class txnLogUtil {

    // Values used to log transaction details
    private static final String TRIGGER_EVENT = 'Trigger';
    private static final String BEFORE_EVENT = 'before';
    private static final String AFTER_EVENT = 'after';
    private static final String INSERT_EVENT = 'insert';
    private static final String UPDATE_EVENT = 'update';
    private static final String DELETE_EVENT = 'delete';
    private static final String SYNC_EVENT = 'Sync';
    private static final String ASYNC_EVENT = 'Async';
    private static final String FUTURE_CONTEXT = 'Future';
    private static final String SCHEDULED_CONTEXT = 'Scheduled';
    private static final String QUEUEABLE_CONTEXT = 'Queueable';
    private static final String BATCH_CONTEXT = 'Batch';

    // Map of Object API Name to Field Names to traverse through all fields of the object
    private static Map<String, List<String>> objFieldNames = new Map<String, List<String>>();

    // Custom setting for configuration
    private static Txn_Log_Settings__c logSettings {
        get {
            if (logSettings == null){
                logSettings = Txn_Log_Settings__c.getInstance();
            }
            return logSettings;
        }
        set;
    }

    // Get a set of trigger names for which the feature is enabled
    private static Set<String> enabledTriggers {
        get {
            if (enabledTriggers == null){
                enabledTriggers = new Set<String>();

                String triggerNames = logSettings.Enabled_Triggers_1__c == null ? '' : logSettings.Enabled_Triggers_1__c;
                triggerNames += logSettings.Enabled_Triggers_2__c == null ? '' : ',' + logSettings.Enabled_Triggers_2__c;
                triggerNames += logSettings.Enabled_Triggers_3__c == null ? '' : ',' + logSettings.Enabled_Triggers_3__c;
                
                for (String triggerName : triggerNames.split(',')){
                    enabledTriggers.add(triggerName.trim());
                }
                System.debug(enabledTriggers);
            }
            return enabledTriggers;
        }
        private set;
    }

    // Generate a transaction Uuid so we can identify which 
    // logs are part of the same transaction
    public static String transactionUuid {
        get{
            if (transactionUuid == null){
                transactionUuid = new Uuid().getValue();
            }
            return transactionUuid;
        }
        private set;
    }  

    // Validate if transaction details should be logged
    public static Boolean loggingEnabled(String triggerName){
        if (logSettings.Log_Transactions__c && enabledTriggers.contains(triggerName)){
            return true;
        } else {
            return false;
        }
    }

    // Main logic to log transaction details
    public static void logTriggerTransaction(List<SObject> newObjects, Map<Id, SObject> mapIdToOld) {
        // Get Object API Name
        String objectApiName = getObjectApiName(newObjects[0]);
        // Get Object Field (API) Names 
        List<String> fieldNames = getAllFieldNames(objectApiName, newObjects[0]);
        // Determine record action
        String recordAction = getRecordAction();
        // Create header records
        Map<Id, Txn_Log__c> transactionLogs = new Map<Id, Txn_Log__c>();
        for (SObject obj : newObjects){
            transactionLogs.put(
                (Id)obj.get('Id'),
                new Txn_Log__c (
                    Object__c = objectApiName,
                    Record_Id__c = (Id)obj.get('Id'),
                    Event__c = 'Trigger',
                    Transaction_Context__c = getTransactionContext(),
                    Record_Action__c = recordAction,
                    Transaction_Id__c = transactionUuid
                )
            );
        }
        insert transactionLogs.values();
        
        // Create a record for each field change
        List<Txn_Field_Change__c> fieldChanges = new List<Txn_Field_Change__c>();
        for (SObject obj : newObjects){
            // Only log field changes if the trigger context is an insert of update
            if (Trigger.isInsert || Trigger.isUpdate){
                for (String thisField : fieldNames){
                    if (Trigger.isInsert || (
                        Trigger.isUpdate && obj.get(thisField) != mapIdToOld.get(obj.Id).get(thisField))) {
                        // New field value
                        String newValue = String.valueOf(obj.get(thisField));
                        // Old field value, make sure to cut off at 32k
                        String oldValue = Trigger.isUpdate ? String.valueOf(mapIdToOld.get(obj.Id).get(thisField))?.left(32768) : null;
                        if (Trigger.isUpdate || (
                            Trigger.isInsert && newValue != null)){
                            fieldChanges.add(
                                new Txn_Field_Change__c(
                                    Txn_Log__c = transactionLogs.get((Id)obj.get('Id')).Id,
                                    Field_API_Name__c = thisField,
                                    New_Value__c = newValue,
                                    Old_Value__c = Trigger.isUpdate ? oldValue : null
                                )
                            );
                        }
                    }
                }
            }
        }
        insert fieldChanges;
    }

    // Determine what action was performed on the record
    private static String getRecordAction(){
        String recordAction = '';

        if (Trigger.isBefore){
            recordAction =BEFORE_EVENT;
        } else if (Trigger.isAfter){
            recordAction = AFTER_EVENT;
        }
        
        if (Trigger.isInsert){
            recordAction += ' ' + INSERT_EVENT;
        } else if (Trigger.isUpdate){
            recordAction += ' ' + UPDATE_EVENT;
        } else if (Trigger.isDelete){
            recordAction += ' ' + DELETE_EVENT;
        }  
        
        return recordAction;
    }

    // Get context of the transaction
    private static String getTransactionContext(){
        String context = SYNC_EVENT;
        
        if (System.isFuture()) {
            context = ASYNC_EVENT + ' - ' + FUTURE_CONTEXT; 
        } else if (System.isQueueable()) {
            context = ASYNC_EVENT + ' - ' + QUEUEABLE_CONTEXT;
        } else if (System.isBatch()) {
            context = ASYNC_EVENT + ' - ' + BATCH_CONTEXT;
        }
        
        if (System.isScheduled()) {
            context += ' - ' + SCHEDULED_CONTEXT;
        }

        return context;
    }

    // Get the object api name
    private static String getObjectApiName(SObject obj){
        return obj.getSObjectType().getDescribe().getName();
    }

    // Get all field names of the object
    private static List<String> getAllFieldNames(String objectApiName, SObject obj){
        List<String> fieldNames = objFieldNames.get(objectApiName);
        if (fieldNames == null){
            fieldNames = new List<String>(Schema.getGlobalDescribe().get(getObjectApiName(obj)).getDescribe().fields.getMap().keySet());
            objFieldNames.put(objectApiName, fieldNames);
        }
        return fieldNames;
    }    

}