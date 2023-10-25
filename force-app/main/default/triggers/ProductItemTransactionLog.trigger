trigger ProductItemTransactionLog on ProductItemTransaction (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('ProductItemTransactionLog').run();
}