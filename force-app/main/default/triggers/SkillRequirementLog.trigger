trigger SkillRequirementLog on SkillRequirement (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('SkillRequirementLog').run();
}