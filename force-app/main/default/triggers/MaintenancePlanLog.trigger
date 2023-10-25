trigger MaintenancePlanLog on MaintenancePlan (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('MaintenancePlanLog').run();
}