trigger FeedbackTrigger on Feedback__c (before insert) {
    TriggersSwitch__c tr = TriggersSwitch__c.getInstance('feedbackTrigger');
    if(tr.isTriggerActive__c){
        FeedbackTriggerHandler handler = new FeedbackTriggerHandler();
        handler.run();
    }
}
