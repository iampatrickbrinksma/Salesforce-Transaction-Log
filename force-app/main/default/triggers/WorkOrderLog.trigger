trigger WorkOrderLog on WorkOrder (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('WorkOrderLog').run();
}