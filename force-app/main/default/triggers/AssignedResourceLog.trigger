trigger AssignedResourceLog on AssignedResource (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog().run();
}