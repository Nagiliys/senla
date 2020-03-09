@isTest
public with sharing class AskQuestionController_Test {
    @TestSetUp
    public static void setUp(){
        id rt = Schema.sObjectType.AutoCenter__c.getRecordTypeInfosByName().get('All').getRecordTypeId();
        AutoCenter__c center = new AutoCenter__c();
        center.recordtypeid=rt;
        center.Name='company name';
        insert center;
        employee__c emp = new employee__c();
        emp.name='worker';
        emp.AutoCenter__c=center.id;
        insert emp;
    }
    
    @isTest
    public static void testGetAutoCenters_1(){
        Test.startTest();
        List<AutoCenter__c> centers = AskQuestionController.getAutoCenters();
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
        String name = firstName+' '+lastName;
        //System.assertEquals(name, lead.Name);
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
        lead ld = new lead();
        ld.FirstName=firstName;
        ld.lastName=lastName;
        ld.Company='Client';
        ld.Phone = phone;
        ld.Email=email;
        ld.Status = 'Open - Not Contacted';
        ld.CurrencyIsoCode='BYN';
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
        Contact ct = new Contact();
        ct.FirstName=firstName;
        ct.lastName=lastName;
        ct.Email=email;
        ct.CurrencyIsoCode='BYN';
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