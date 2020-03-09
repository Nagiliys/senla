@isTest
public with sharing class FeedbackTriggerHandler_Test {
    @IsTest
    static void test_1(){
        Feedback__c fb = new Feedback__c(
            ct__c = '55das8d4asd4sad'
        );
        Test.starttest();
        insert fb;
        Test.stoptest();
        system.assertEquals('55das8d4asd4sad', fb.Contact__c);
        system.assertEquals('', fb.ct__c);
    }
}
