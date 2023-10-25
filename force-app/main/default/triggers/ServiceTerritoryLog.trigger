trigger ServiceTerritoryLog on ServiceTerritory (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('ServiceTerritoryLog').run();
}