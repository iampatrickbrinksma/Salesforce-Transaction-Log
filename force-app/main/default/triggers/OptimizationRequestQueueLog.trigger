trigger OptimizationRequestQueueLog on FSL__Optimization_Request_Queue__c (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('OptimizationRequestQueueLog').run();
}