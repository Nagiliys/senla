@isTest
public with sharing class CaseTriggerHandler_Test {
    @TestSetup
    static void setup(){
        employee__c emp = new employee__c();
        emp.name='worker';
        insert emp;
    }

    @IsTest
    static void testBeforeInsert_1(){
        Test.starttest();
        Case  cs= new Case();
        cs.SuppliedName = 'first last';
        cs.SuppliedEmail = 'a@b.c';
        cs.Origin = 'Email';
        insert cs;
        Test.stoptest();
        List<Lead> lds = [select Id from lead];
        system.assertEquals(1, lds.size());
    }

    @IsTest
    static void testBeforeInsert_2(){
        Lead ld = new lead();
        ld.lastname='leadname';
        ld.company='client';
        ld.status='Open - Not Contacted';
        ld.email = 'a@b.c';
        insert ld;
        Test.starttest();
        Case  cs= new Case();
        cs.SuppliedName = 'first last';
        cs.SuppliedEmail = 'a@b.c';
        cs.Origin = 'Email';
        insert cs;
        Test.stoptest();

        //system.assertEquals(ld.Id, cs.Lead__c);
    }
    @IsTest
    static void testBeforeInsert_3(){
        Contact ct = new Contact();
        ct.lastname='leadname';
        ct.email = 'a@b.c';
        insert ct;
        Test.starttest();
        Case  cs= new Case();
        cs.SuppliedName = 'first last';
        cs.SuppliedEmail = 'a@b.c';
        cs.Origin = 'Email';
        insert cs;
        Test.stoptest();
        //system.assertEquals(ct.Id, cs.ContactId);
    }
}