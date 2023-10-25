trigger OptimizationRequestLog on FSL__Optimization_Request__c (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('OptimizationRequestLog').run();
}