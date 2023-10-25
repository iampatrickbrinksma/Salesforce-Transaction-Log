trigger UserSettingTerritoryLog on FSL__User_Setting_Territory__c (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('UserSettingTerritoryLog').run();
}