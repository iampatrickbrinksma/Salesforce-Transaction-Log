trigger GanttPaletteLog on FSL__GanttPalette__c (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('GanttPaletteLog').run();
}