trigger MaintenanceAssetLog on MaintenanceAsset (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('MaintenanceAssetLog').run();
}