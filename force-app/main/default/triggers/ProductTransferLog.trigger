trigger ProductTransferLog on ProductTransfer (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('ProductTransferLog').run();
}