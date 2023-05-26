trigger ResourcePreferenceLog on ResourcePreference (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog().run();
}