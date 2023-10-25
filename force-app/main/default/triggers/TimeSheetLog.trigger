trigger TimeSheetLog on TimeSheet (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('TimeSheetLog').run();
}