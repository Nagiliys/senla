public without sharing class FeedbackController {
    @AuraEnabled
    public static boolean isPossibleToCreateFeedback(String ct){
        Integer fb = [select count() from Feedback__c where Contact__c=:ct];
        Integer opp = [select count() from Opportunity where Contact__c=:ct and StageName='Closed Won'];
        return opp>fb;
    }
}
