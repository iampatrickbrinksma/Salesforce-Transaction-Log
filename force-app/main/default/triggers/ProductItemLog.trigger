trigger ProductItemLog on ProductItem (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('ProductItemLog').run();
}