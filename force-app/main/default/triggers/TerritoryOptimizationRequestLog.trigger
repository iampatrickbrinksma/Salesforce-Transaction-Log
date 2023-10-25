trigger TerritoryOptimizationRequestLog on FSL__Territory_Optimization_Request__c (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('TerritoryOptimizationRequestLog').run();
}