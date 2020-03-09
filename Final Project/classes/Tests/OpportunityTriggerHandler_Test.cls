@IsTest
public with sharing class OpportunityTriggerHandler_Test {
    @TestSetup
    static void setup(){
        Opportunity opp = new Opportunity(
            name = 'test opp',
            CloseDate=Date.today().addMonths(1),
            StageName='Prospecting'
        );//name close date stage
        insert opp;
        Case cs = new Case(
            status='New',
            origin='Web',
            Opportunity__c=opp.id
        );
        insert cs;
    }

    @IsTest
    static void testClosedWon_1(){//lead to contact
        Lead ld = new Lead(
            firstName='firstName',
            lastName='lastName',
            phone='213123',
            email='ab@mail.ru',
            company='Client',
            status='Open Not Contacted'
        );
        insert ld;
        Opportunity opp2 = new Opportunity(
            name = 'test opp 2',
            CloseDate=Date.today().addMonths(1),
            StageName='Prospecting',
            Lead__c=ld.id
        );
        insert opp2;
        Opportunity opp = [select StageName, Lead__c from Opportunity limit 1];
        Test.startTest();
        opp.Lead__c=ld.Id;
        opp.StageName='Closed Won';
        update opp;
        Test.stopTest();
        Case cs = [select status from Case limit 1];
        system.assertEquals('Closed', cs.status);
        List<Contact> cts = [select id from Contact];
        List<Lead> lds = [select id from lead];
        system.assertEquals(1, cts.size());
        system.assertEquals(0, lds.size());
    }

    @IsTest
    static void testClosedWon_2(){//update contact
        Contact ct = new Contact(
            firstName='firstName',
            lastName='lastName',
            phone='213123',
            email='ab@mail.ru'
        );
        insert ct;
        Opportunity opp = [select StageName, Contact__c from Opportunity limit 1];
        Test.startTest();
        opp.Contact__c=ct.Id;
        opp.StageName='Closed Won';
        update opp;
        Test.stopTest();
        Case cs = [select status from Case limit 1];
        system.assertEquals('Closed', cs.status);
    }

    @IsTest
    static void testClosedLost_1(){
        Opportunity opp = [select StageName from Opportunity limit 1];
        Test.startTest();
        opp.StageName='Closed Lost';
        update opp;
        Test.stopTest();
        Case cs = [select status from Case limit 1];
        system.assertEquals('Closed', cs.status);
        
    }

    @isTest
    static void testUndeleteTriggerHandler(){
        Opportunity opp = [select Id from Opportunity limit 1];
        delete opp;
		undelete [SELECT Id FROM Opportunity WHERE IsDeleted = true ALL ROWS];        
    }
}
