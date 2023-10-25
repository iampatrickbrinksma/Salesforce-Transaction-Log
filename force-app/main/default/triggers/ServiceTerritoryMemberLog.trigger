trigger ServiceTerritoryMemberLog on ServiceTerritoryMember (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('ServiceTerritoryMemberLog').run();
}