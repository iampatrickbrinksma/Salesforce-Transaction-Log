/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Class for logging transaction details which is called from any Apex Trigger from which you want
* to log the transaction details from
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Patrick Brinksma   <patrick@brinksma.es>
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class txnLog {

    // Name of the trigger to validate if logging is enabled
    // for the specific trigger, which is managed in a custom setting
    private String triggerName;

    // Constructor
    public txnLog(String triggerName) {
        this.triggerName = triggerName;
    }

    // Log transaction details
    public void run(){
        // Only run if feature is enabled, also for this trigger
        if (txnLogUtil.loggingEnabled(this.triggerName)){

            // Values from before the trigger, only applies to updates
            Map<Id, SObject> idToOldObj;
            if (Trigger.isUpdate) idToOldObj = (Map<Id, SObject>)Trigger.oldMap;

            // Updated or inserted values
            List<SObject> newObjects;
            if (Trigger.isDelete) {
                newObjects = Trigger.old;
            } else {
                newObjects = Trigger.new;
            }

            // Log transaction details
            txnLogUtil.logTriggerTransaction(newObjects, idToOldObj);
        }

    }

}