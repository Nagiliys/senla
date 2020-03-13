trigger OpportunityTrigger on Opportunity (after update) {
    TriggersSwitch__c tr = TriggersSwitch__c.getInstance('opportunityTrigger');
    if(tr.isTriggerActive__c){
        OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
        handler.run();
    }
}