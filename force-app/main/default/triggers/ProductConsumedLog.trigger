trigger ProductConsumedLog on ProductConsumed (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('ProductConsumedLog').run();
}