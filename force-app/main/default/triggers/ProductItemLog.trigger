trigger ProductItemLog on ProductItem (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('ProductItemLog').run();
}