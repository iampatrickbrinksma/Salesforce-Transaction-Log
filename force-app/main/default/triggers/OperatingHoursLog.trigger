trigger OperatingHoursLog on OperatingHours (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('OperatingHoursLog').run();
}