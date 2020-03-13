@isTest
public with sharing class AskQuestionController_Test {
    @TestSetUp
    public static void setUp(){
        TriggersSwitch__c trcase = new TriggersSwitch__c();
        trcase.Name='caseTrigger';
        trcase.isTriggerActive__c=true;
        insert trcase;
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
        AskQuestionController.Wrapper wrapper = getWrapper();
        
        Test.startTest();
        AskQuestionController.createCase(wrapper);
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
        AskQuestionController.Wrapper wrapper = getWrapper();
        lead ld = new lead(
            FirstName=wrapper.firstName,
            lastName=wrapper.lastName,
            Company='Client',
            Phone = wrapper.phone,
            Email=wrapper.email,
            Status = 'Open - Not Contacted',
            CurrencyIsoCode='BYN'
        );
        insert ld;

        Test.startTest();
        AskQuestionController.createCase(wrapper);
        Test.stopTest();
        
        Case cs = [select Id, employee__c, ContactId, Lead__c from case limit 1];
        employee__c emp = [select Id from employee__c limit 1];
        System.assertEquals(emp.Id, cs.employee__c);
        System.assertEquals(ld.Id, cs.Lead__c);
        System.assertEquals(null, cs.ContactId);   
    }

    @isTest
    public static void testCreateCase_3(){//test update contact
        AskQuestionController.Wrapper wrapper = getWrapper();
        Contact ct = new Contact(
            FirstName=wrapper.firstName,
            lastName=wrapper.lastName,
            Email=wrapper.email,
            CurrencyIsoCode='BYN'
        );
        insert ct;

        Test.startTest();
        AskQuestionController.createCase(wrapper);
        Test.stopTest();

        Case cs = [select Id, employee__c, ContactId, Lead__c from case limit 1];
        employee__c emp = [select Id from employee__c limit 1];
        System.assertEquals(emp.Id, cs.employee__c);
        System.assertEquals(ct.Id, cs.ContactId);
        System.assertEquals(null, cs.Lead__c); 
    }
    private static AskQuestionController.Wrapper getWrapper(){
        AskQuestionController.Wrapper wrapper = AskQuestionController.getWrapper();
        wrapper.firstName = 'firstName';
        wrapper.lastName = 'lastName';
        wrapper.phone = '+1(800)12345';
        wrapper.email = 'a@b.c';
        AutoCenter__c center = [select Id from AutoCenter__c limit 1];
        wrapper.idCenter = center.id;
        wrapper.subject = 'subject';
        wrapper.description = 'description';
        return wrapper;
    }
}