trigger ProductRequiredLog on ProductRequired (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('ProductRequiredLog').run();
}