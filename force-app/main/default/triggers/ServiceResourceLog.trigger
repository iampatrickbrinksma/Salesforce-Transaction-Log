trigger ServiceResourceLog on ServiceResource (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('ServiceResourceLog').run();
}