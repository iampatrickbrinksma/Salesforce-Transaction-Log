trigger WorkStepLog on WorkStep (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('WorkStepLog').run();
}