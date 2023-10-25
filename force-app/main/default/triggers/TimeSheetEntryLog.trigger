trigger TimeSheetEntryLog on TimeSheetEntry (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('TimeSheetEntryLog').run();
}