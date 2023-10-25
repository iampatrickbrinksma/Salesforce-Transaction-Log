trigger CrewManagementUserSettingsTerritoryLog on FSL__Crew_Management_User_Settings_Territory__c (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('CrewManagementUserSettingsTerritoryLog').run();
}