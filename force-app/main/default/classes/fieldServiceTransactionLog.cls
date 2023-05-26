public with sharing class fieldServiceTransactionLog {

    public fieldServiceTransactionLog() {}

    public void run(){
        if (!fieldServiceTransactionLogUtil.loggingEnabled) return;

        List<SObject> newObjects = Trigger.new;
        Map<Id, SObject> idToOldObj;
        if (Trigger.isUpdate) idToOldObj = (Map<Id, SObject>)Trigger.oldMap;
        if (Trigger.isDelete) newObjects = Trigger.old;
        fieldServiceTransactionLogUtil.logTriggerTransaction(newObjects, idToOldObj);
    }

}