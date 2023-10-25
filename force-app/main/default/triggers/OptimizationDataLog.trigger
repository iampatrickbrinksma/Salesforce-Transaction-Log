trigger OptimizationDataLog on FSL__Optimization_Data__c (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('OptimizationDataLog').run();
}