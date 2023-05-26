public with sharing class fieldServiceTransactionLogUtil {

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

    public static Boolean loggingEnabled {
        get {
            if (loggingEnabled == null){
                loggingEnabled = Field_Service_Transaction_Log_Settings__c.getInstance().Log_Transactions__c;
            }
            return loggingEnabled;
        }
        private set;
    }

    public static String transactionUuid {
        get{
            if (transactionUuid == null){
                transactionUuid = new Uuid().getValue();
            }
            return transactionUuid;
        }
        private set;
    }  

    public static void logTriggerTransaction(List<SObject> newObjects, Map<Id, SObject> mapIdToOld) {
        if (!loggingEnabled) return;

        String objectApiName = getObjectApiName(newObjects[0]);
        
        List<String> fieldNames = getAllFieldNames(newObjects[0]);

        String recordAction = getRecordAction();
    
        Map<Id, Field_Service_Transaction_Log__c> transactionLogs = new Map<Id, Field_Service_Transaction_Log__c>();
        for (SObject obj : newObjects){
            transactionLogs.put(
                (Id)obj.get('Id'),
                new Field_Service_Transaction_Log__c (
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

        List<Field_Service_Transaction_Field_Change__c> fieldChanges = new List<Field_Service_Transaction_Field_Change__c>();
        for (SObject obj : newObjects){
            if (Trigger.isInsert || Trigger.isUpdate){
                for (String thisField : fieldNames){
                    if (Trigger.isInsert || (
                        Trigger.isUpdate && obj.get(thisField) != mapIdToOld.get(obj.Id).get(thisField))) {
                        String newValue = String.valueOf(obj.get(thisField));
                        String oldValue = Trigger.isUpdate ? String.valueOf(mapIdToOld.get(obj.Id).get(thisField))?.left(32768) : null;
                        if (Trigger.isUpdate || (
                            Trigger.isInsert && newValue != null)){
                            fieldChanges.add(
                                new Field_Service_Transaction_Field_Change__c(
                                    Field_Service_Transaction_Log__c = transactionLogs.get((Id)obj.get('Id')).Id,
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

    private static String getObjectApiName(SObject obj){
        return obj.getSObjectType().getDescribe().getName();
    }

    private static List<String> getAllFieldNames(SObject obj){
        return new List<String>(Schema.getGlobalDescribe().get(getObjectApiName(obj)).getDescribe().fields.getMap().keySet());
    }    

}