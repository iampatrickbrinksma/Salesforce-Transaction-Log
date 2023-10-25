trigger ShiftLog on Shift (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('ShiftLog').run();
}