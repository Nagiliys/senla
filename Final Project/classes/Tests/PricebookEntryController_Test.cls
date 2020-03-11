@isTest
public with sharing class PricebookEntryController_Test {
    @IsTest
    static void test_1(){//Engine_Capacity__c, product2.Transmission__c, product2.Drive_unit__c, UnitPrice
        Product2 pr = new Product2(
            Name='geely atlas base',
            family='geely atlas',
            ProductCode='gab',
            Engine_Capacity__c='',
            Transmission__c='',
            Drive_unit__c=''
        );
        insert pr;

        Product2 pr2 = new Product2(
            Name='geely coolray base',
            family='geely coolray',
            ProductCode='gcb',
            Engine_Capacity__c='',
            Transmission__c='',
            Drive_unit__c=''
        );
        insert pr2;


        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = pr.Id,
            UnitPrice = 10000, 
            IsActive = true
            );
        insert standardPrice;

        PricebookEntry standardPrice2 = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = pr2.Id,
            UnitPrice = 10000, 
            IsActive = true
            );
        insert standardPrice2;

        Pricebook2 pb = new Pricebook2(
            name='Standart Geely Price Book',
            isactive=true
        );
        insert pb;
        pricebookentry pbe= new pricebookentry(
            CurrencyIsoCode='BYN',
            Pricebook2id=pb.id,
            Product2id=pr.id,
            Unitprice=1234,
            isactive = true
        );
        insert pbe;

        Rates__c rt = new Rates__c(
            Name='BYN',
            Rate__c=1.0
        );
        insert rt;

        PageReference pageRef = Page.GeelyPrice;
        pageRef.getParameters().put('car','gelly atlas');
        pageRef.getParameters().put('curr','BYN');
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(pbe);
        
        PricebookEntryController PbEC = new PricebookEntryController(sc);
        
    }
}
