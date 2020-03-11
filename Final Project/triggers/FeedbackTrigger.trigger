trigger FeedbackTrigger on Feedback__c (before insert) {
    FeedbackTriggerHandler handler = new FeedbackTriggerHandler();
    handler.run();
}
