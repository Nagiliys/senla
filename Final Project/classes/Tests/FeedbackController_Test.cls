@isTest
public class FeedbackController_Test {
    @IsTest
    static void testIsPossibleToCreateFeedback_1(){
        Contact ct = new Contact(
            lastname='name'
        );
        Test.startTest();
        insert ct;
        Boolean isPossible = FeedbackController.isPossibleToCreateFeedback(ct.Id);
        Test.stopTest();
        system.assertEquals(false, isPossible);
    }
    @IsTest
    static void testIsPossibleToCreateFeedback_2(){
        Contact ct = new Contact(
            lastname='name'
        );
        insert ct;
        Opportunity opp = new Opportunity(
            name = 'test opp',
            CloseDate=Date.today().addMonths(1),
            StageName='Closed Won',
            Contact__c=ct.id
        );
        insert opp;
        Test.startTest();
        Boolean isPossible = FeedbackController.isPossibleToCreateFeedback(ct.Id);
        Test.stopTest();
        system.assertEquals(true, isPossible);
    }
}
