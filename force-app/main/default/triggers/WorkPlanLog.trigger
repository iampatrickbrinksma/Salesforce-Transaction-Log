trigger WorkPlanLog on WorkPlan (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('WorkPlanLog').run();
}