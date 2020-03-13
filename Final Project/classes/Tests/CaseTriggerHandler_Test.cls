@isTest
public with sharing class CaseTriggerHandler_Test {
    @TestSetup
    static void setup(){
        TriggersSwitch__c tr = new TriggersSwitch__c();
        tr.Name='caseTrigger';
        tr.isTriggerActive__c=true;
        insert tr;
        employee__c emp = new employee__c(
            name='worker'
        );
        insert emp;
    }
    @IsTest
    static void testBeforeInsert_1(){
        Case  cs= new Case(
            SuppliedName = 'first last',
            SuppliedEmail = 'a@b.c',
            Origin = 'Email'
        );

        Test.starttest();
        insert cs;
        Test.stoptest();
        
        List<Lead> lds = [select Id from lead];
        system.assertEquals(1, lds.size());
    }
    @IsTest
    static void testBeforeInsert_2(){
        Lead ld = new lead(
            lastname='leadname',
            company='client',
            status='Open - Not Contacted',
            email = 'a@b.c'
        );
        insert ld;
        Case  cs= new Case(
            SuppliedName = 'first last',
            SuppliedEmail = 'a@b.c',
            Origin = 'Email'
        );

        Test.starttest();
        insert cs;
        Test.stoptest();
        string i = cs.Id;
		cs = [select Lead__c from case where id=:i];
        system.assertEquals(ld.Id, cs.Lead__c);
    }
    @IsTest
    static void testBeforeInsert_3(){
        Contact ct = new Contact(
            lastname='leadname',
            email = 'a@b.c'
        );
        insert ct;
        Case  cs= new Case(
            SuppliedName = 'first last',
            SuppliedEmail = 'a@b.c',
            Origin = 'Email'
        );

        Test.starttest();
        insert cs;
        Test.stoptest();
		string i = cs.Id;
		cs = [select ContactId from case where id=:i];
        system.assertEquals(ct.Id, cs.ContactId);
    }
}