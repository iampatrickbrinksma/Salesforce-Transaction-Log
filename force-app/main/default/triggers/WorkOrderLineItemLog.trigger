trigger WorkOrderLineItemLog on WorkOrderLineItem  (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog().run();
}