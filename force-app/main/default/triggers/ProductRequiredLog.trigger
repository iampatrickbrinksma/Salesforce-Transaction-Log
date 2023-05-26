trigger ProductRequiredLog on ProductRequired (before insert, before update, before delete, after insert, after update, after delete) {
    if (Trigger.isInsert) sfsUtil.logRecordChanges((List<SObject>)Trigger.new, null);
    if (Trigger.isUpdate) sfsUtil.logRecordChanges((List<SObject>)Trigger.new, (Map<Id, SObject>)Trigger.oldMap);
    if (Trigger.isDelete) sfsUtil.logRecordChanges((List<SObject>)Trigger.old, null);
}