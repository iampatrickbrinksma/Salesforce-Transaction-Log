trigger AddressLog on Address (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('AddressLog').run();
}