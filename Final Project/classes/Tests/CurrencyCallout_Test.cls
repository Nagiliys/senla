@isTest
global class CurrencyCallout_Test {
    @isTest
    global static void test(){

        Test.setMock(HttpCalloutMock.class, new CurrencyCalloutMock());
        // /Double result = CurrencyCallouts.getCurrency('EUR');
        //System.assertEquals(2.3830, result);

    }
}
