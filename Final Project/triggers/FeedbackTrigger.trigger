trigger FeedbackTrigger on Feedback__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    FeedbackTriggerHandler handler = new FeedbackTriggerHandler();
    handler.run();
}
