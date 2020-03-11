trigger OpportunityTrigger on Opportunity (before update) {
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
    handler.run();
}