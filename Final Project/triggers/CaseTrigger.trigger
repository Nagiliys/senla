trigger CaseTrigger on Case (before insert) {
    CaseTriggerHandler handler = new CaseTriggerHandler();
    handler.run();
}