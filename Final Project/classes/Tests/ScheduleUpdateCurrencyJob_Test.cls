@istest
public with sharing class ScheduleUpdateCurrencyJob_Test {
    @IsTest
    static void test_1(){
        Rates__c rt = new Rates__c();
        rt.Name='EUR';
        rt.Rate__c=1.0;
        insert rt;
        //String CRON_EXP = '0 0 0 3 3 ? 2020';
        Test.setMock(HttpCalloutMock.class, new CurrencyCalloutMock());
        Test.startTest();
        CurrencyRatesUpdate.futureUpdateRates();
        //String jobId = System.schedule('ScheduleUpdateCurrencyJob', CRON_EXP, new ScheduleUpdateCurrencyJob());         
        Test.stopTest();
        
    }
}
