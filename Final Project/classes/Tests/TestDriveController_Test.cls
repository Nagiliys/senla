@isTest
public with sharing class TestDriveController_Test {
    @TestSetup
    public static void setup(){
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
        String firstName = '1st'; 
        String lastName='8th';
        String phone = '123456';
        String email = 'a@b.c';
        AutoCenter__c center = [select Id from AutoCenter__c limit 1];
        String idCenter = center.Id;

        Test.starttest();
        TestDriveController.createCase(firstName, lastName, phone, email, idCenter);
        Test.stoptest();

        list<Lead> lds = [select id, email from Lead];
        List<Case> cases = [select Lead__c from case];
        system.assertEquals(1, cases.size());
        system.assertEquals(1, lds.size());
        system.assertEquals(lds[0].Id, cases[0].Lead__c);
    }

    @isTest
    public static void testCreateCase_2(){//update lead
        String firstName = '1st'; 
        String lastName='8th';
        String phone = '123456';
        String email = 'a@b.c';
        AutoCenter__c center = [select Id from AutoCenter__c limit 1];
        String idCenter = center.Id;
        Lead ld = new Lead(
            firstName=firstName,
            lastName=lastName,
            phone=phone,
            email=email,
            company='Client',
            status='Open Not Contacted'
        );
        insert ld;

        Test.starttest();
        TestDriveController.createCase(firstName, lastName, phone, email, idCenter);
        Test.stoptest();

        List<Case> cases = [select Lead__c from case];
        system.assertEquals(1, cases.size());
        system.assertEquals(ld.Id, cases[0].Lead__c);
    }

    @isTest
    public static void testCreateCase_3(){//update contact
        String firstName = '1st'; 
        String lastName='8th';
        String phone = '123456';
        String email = 'a@b.c';
        AutoCenter__c center = [select Id from AutoCenter__c limit 1];
        String idCenter = center.Id;
        Contact ct = new Contact(
            firstName=firstName,
            lastName=lastName,
            phone=phone,
            email=email
        );
        insert ct;

        Test.starttest();
        TestDriveController.createCase(firstName, lastName, phone, email, idCenter);
        Test.stoptest();

        List<Case> cases = [select ContactId from case];
        system.assertEquals(1, cases.size());
        system.assertEquals(ct.Id, cases[0].ContactId);
    }
}
