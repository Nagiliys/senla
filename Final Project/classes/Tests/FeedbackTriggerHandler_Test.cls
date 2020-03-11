@isTest
public with sharing class FeedbackTriggerHandler_Test {
    @IsTest
    static void test_1(){
        Contact ct = new Contact(
            lastname='leadname'
        );
        insert ct;

        Feedback__c fb = new Feedback__c(
            ct__c = ct.Id
        );

        Test.starttest();
        insert fb;
        Test.stoptest();
        fb = [select Contact__c, ct__c from Feedback__c limit 1];
        system.assertEquals(ct.Id, fb.Contact__c);
        system.assertEquals(null, fb.ct__c);
    }
}
