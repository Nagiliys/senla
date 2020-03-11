@isTest
public with sharing class AskQuestionController_Test {
    @TestSetUp
    public static void setUp(){
        id rt = Schema.sObjectType.AutoCenter__c.getRecordTypeInfosByName().get('All').getRecordTypeId();
        AutoCenter__c center = new AutoCenter__c(
            recordtypeid=rt,
            Name='company name'
        );
        insert center;
        employee__c emp = new employee__c(
            name='worker',
            AutoCenter__c=center.id
        );
        insert emp;
    }
    
    @isTest
    public static void testGetAutoCenters_1(){
        Test.startTest();
        List<AutoCenter__c> centers = AskQuestionController.getAutoCenters();
        Test.stopTest();
        
        System.assertEquals('company name', centers[0].Name);
        System.assertEquals(1, centers.size());
    }

    @isTest
    public static void testCreateCase_1(){//test create lead
        String firstName = 'firstName';
        String lastName = 'lastName';
        String phone = '+1(800)12345';
        String email = 'a@b.c';
        AutoCenter__c center = [select Id from AutoCenter__c limit 1];
        String idCenter = center.id;
        String subject = 'subject';
        String description = 'description';

        Test.startTest();
        AskQuestionController.createCase(firstName, lastName, phone, email, idCenter, subject, description);
        Test.stopTest();

        Lead ld = [select Id, Name from Lead limit 1];
        Case cs = [select Id, employee__c, ContactId, Lead__c from case limit 1];
        employee__c emp = [select Id from employee__c limit 1];
        System.assertEquals(emp.Id, cs.employee__c);
        System.assertEquals(ld.Id, cs.Lead__c);
        System.assertEquals(null, cs.ContactId);
    }

    @isTest
    public static void testCreateCase_2(){//test update lead
        String firstName = 'firstName';
        String lastName = 'lastName';
        String phone = '+1(800)12345';
        String email = 'a@b.c';
        AutoCenter__c center = [select Id from AutoCenter__c limit 1];
        String idCenter = center.id;
        String subject = 'subject';
        String description = 'description';
        lead ld = new lead(
            FirstName=firstName,
            lastName=lastName,
            Company='Client',
            Phone = phone,
            Email=email,
            Status = 'Open - Not Contacted',
            CurrencyIsoCode='BYN'
        );
        insert ld;

        Test.startTest();
        AskQuestionController.createCase(firstName, lastName, phone, email, idCenter, subject, description);
        Test.stopTest();
        
        Case cs = [select Id, employee__c, ContactId, Lead__c from case limit 1];
        employee__c emp = [select Id from employee__c limit 1];
        System.assertEquals(emp.Id, cs.employee__c);
        System.assertEquals(ld.Id, cs.Lead__c);
        System.assertEquals(null, cs.ContactId);   
    }

    @isTest
    public static void testCreateCase_3(){//test update contact
        String firstName = 'firstName';
        String lastName = 'lastName';
        String phone = '+1(800)12345';
        String email = 'a@b.c';
        AutoCenter__c center = [select Id from AutoCenter__c limit 1];
        String idCenter = center.id;
        String subject = 'subject';
        String description = 'description';
        Contact ct = new Contact(
            FirstName=firstName,
            lastName=lastName,
            Email=email,
            CurrencyIsoCode='BYN'
        );
        insert ct;

        Test.startTest();
        AskQuestionController.createCase(firstName, lastName, phone, email, idCenter, subject, description);
        Test.stopTest();

        Case cs = [select Id, employee__c, ContactId, Lead__c from case limit 1];
        employee__c emp = [select Id from employee__c limit 1];
        System.assertEquals(emp.Id, cs.employee__c);
        System.assertEquals(ct.Id, cs.ContactId);
        System.assertEquals(null, cs.Lead__c); 
    }
}