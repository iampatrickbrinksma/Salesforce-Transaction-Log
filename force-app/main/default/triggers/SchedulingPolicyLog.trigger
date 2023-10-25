trigger SchedulingPolicyLog on FSL__Scheduling_Policy__c (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('SchedulingPolicyLog').run();
}