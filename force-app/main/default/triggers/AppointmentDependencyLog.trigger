trigger AppointmentDependencyLog on FSL__Time_Dependency__c (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('AppointmentDependencyLog').run();
}