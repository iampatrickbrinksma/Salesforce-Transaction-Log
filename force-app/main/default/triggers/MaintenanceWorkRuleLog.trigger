trigger MaintenanceWorkRuleLog on MaintenanceWorkRule (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('MaintenanceWorkRuleLog').run();
}