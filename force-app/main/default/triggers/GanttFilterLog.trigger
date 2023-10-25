trigger GanttFilterLog on FSL__Gantt_Filter__c (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('GanttFilterLog').run();
}