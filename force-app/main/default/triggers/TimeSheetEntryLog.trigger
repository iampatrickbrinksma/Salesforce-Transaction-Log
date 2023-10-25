trigger TimeSheetEntryLog on TimeSheetEntry (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('TimeSheetEntryLog').run();
}