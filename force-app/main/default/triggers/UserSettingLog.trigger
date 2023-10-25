trigger UserSettingLog on FSL__UserSetting__c (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('UserSettingLog').run();
}