trigger CaseTrigger on Case (before insert) {
    TriggersSwitch__c tr = TriggersSwitch__c.getInstance('caseTrigger');
    if(tr.isTriggerActive__c){
        CaseTriggerHandler handler = new CaseTriggerHandler();
        handler.run();
    }
}