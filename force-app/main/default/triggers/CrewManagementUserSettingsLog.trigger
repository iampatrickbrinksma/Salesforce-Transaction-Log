trigger CrewManagementUserSettingsLog on FSL__Crew_Management_User_Settings__c (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('CrewManagementUserSettingsLog').run();
}