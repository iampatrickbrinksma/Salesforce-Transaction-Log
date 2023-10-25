trigger ResourceAbsenceLog on ResourceAbsence (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('ResourceAbsenceLog').run();
}