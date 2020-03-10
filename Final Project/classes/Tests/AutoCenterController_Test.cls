@isTest
public with sharing class AutoCenterController_Test {
    @TestSetup
    public static void setUp(){
        id rtDiller = Schema.sObjectType.AutoCenter__c.getRecordTypeInfosByName().get('Diller').getRecordTypeId();
        id rtService = Schema.sObjectType.AutoCenter__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        AutoCenter__c centerDiller = new AutoCenter__c();
        centerDiller.recordtypeid=rtDiller;
        centerDiller.Name='company diller';
        centerDiller.City__c='Grodno';
        insert centerDiller;
        AutoCenter__c centerService = new AutoCenter__c();
        centerService.recordtypeid=rtService;
        centerService.Name='company service';
        centerService.City__c='Minsk';
        insert centerService;
    }

    @isTest
    public static void testGetAutoCenters_1(){
        List<AutoCenter__c> centers = AutoCenterController.getAutoCenters();
        System.assertEquals(2, centers.size());
    }

    @isTest
    public static void testGetAutoCentersById_1(){
        AutoCenter__c test = new AutoCenter__c();
        test.Name='test name';
        id rt = Schema.sObjectType.AutoCenter__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        test.recordtypeid=rt;
        insert test;
        AutoCenter__c center = AutoCenterController.getAutoCentersById(test.Id);
        System.assertEquals(test.Name, center.Name);
    }

    @isTest
    public static void testGetAutoCentersByRecordType_1(){
        List<AutoCenter__c> centers = AutoCenterController.getAutoCentersByRecordType('All');
        System.assertEquals(2, centers.size());
    }

    @isTest
    public static void testGetAutoCentersByRecordType_2(){
        List<AutoCenter__c> centers = AutoCenterController.getAutoCentersByRecordType('Diller');
        System.assertEquals(1, centers.size());

    }

    @isTest
    public static void testGetMapAutoCenters_1(){
        Map<String, String> centerMap = AutoCenterController.getMapAutoCenters('mpany', 'All');
        System.assertEquals(2, centerMap.size());
    }

    @isTest
    public static void testGetMapAutoCenters_2(){
        Map<String, String> centerMap = AutoCenterController.getMapAutoCenters('mpany', 'Service');
        System.assertEquals(1, centerMap.size());
    }
}
