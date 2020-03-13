@isTest
public with sharing class TestDriveController_Test {
    @TestSetup
    public static void setup(){
        TriggersSwitch__c trcase = new TriggersSwitch__c();
        trcase.Name='caseTrigger';
        trcase.isTriggerActive__c=true;
        insert trcase;
        id rtDiller = Schema.sObjectType.AutoCenter__c.getRecordTypeInfosByName().get('Diller').getRecordTypeId();
        AutoCenter__c centerDiller = new AutoCenter__c(
            recordtypeid=rtDiller,
            Name='company diller',
            City__c='Grodno'
        );
        insert centerDiller;
        employee__c emp = new employee__c(
            name='worker',
            AutoCenter__c=centerDiller.id
        );
        insert emp;

        id rtService = Schema.sObjectType.AutoCenter__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        AutoCenter__c centerService = new AutoCenter__c(
            recordtypeid=rtService,
            Name='company service',
            City__c='Minsk'
        );
        insert centerService;

    }

    @isTest
    public static void testGetAutoCenters_1(){
        Test.starttest();
        List<AutoCenter__c> ac = TestDriveController.getAutoCenters();
        Test.stoptest();

        system.assertEquals(1, ac.size());
    }
    

    @isTest
    public static void testCreateCase_1(){//create lead
        TestDriveController.Wrapper wrapper = getWrapper();

        Test.starttest();
        TestDriveController.createCase(wrapper);
        Test.stoptest();

        list<Lead> lds = [select id, email from Lead];
        List<Case> cases = [select Lead__c from case];
        system.assertEquals(1, cases.size());
        system.assertEquals(1, lds.size());
        system.assertEquals(lds[0].Id, cases[0].Lead__c);
    }

    @isTest
    public static void testCreateCase_2(){//update lead
        TestDriveController.Wrapper wrapper = getWrapper();
        Lead ld = new Lead(
            firstName=wrapper.firstName,
            lastName=wrapper.lastName,
            phone=wrapper.phone,
            email=wrapper.email,
            company='Client',
            status='Open Not Contacted'
        );
        insert ld;

        Test.starttest();
        TestDriveController.createCase(wrapper);
        Test.stoptest();

        List<Case> cases = [select Lead__c from case];
        system.assertEquals(1, cases.size());
        system.assertEquals(ld.Id, cases[0].Lead__c);
    }

    @isTest
    public static void testCreateCase_3(){//update contact
        TestDriveController.Wrapper wrapper = getWrapper();
        Contact ct = new Contact(
            firstName=wrapper.firstName,
            lastName=wrapper.lastName,
            phone=wrapper.phone,
            email=wrapper.email
        );
        insert ct;

        Test.starttest();
        TestDriveController.createCase(wrapper);
        Test.stoptest();

        List<Case> cases = [select ContactId from case];
        system.assertEquals(1, cases.size());
        system.assertEquals(ct.Id, cases[0].ContactId);
    }
    private static TestDriveController.Wrapper getWrapper(){
        TestDriveController.Wrapper wrapper = TestDriveController.getWrapper();
        wrapper.firstName = 'firstName';
        wrapper.lastName = 'lastName';
        wrapper.phone = '+1(800)12345';
        wrapper.email = 'a@b.c';
        AutoCenter__c center = [select Id from AutoCenter__c limit 1];
        wrapper.idCenter = center.id;
        return wrapper;
    }
}
