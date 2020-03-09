@isTest
public with sharing class PricebookEntryController_Test {
    @IsTest
    static void test_1(){//Engine_Capacity__c, product2.Transmission__c, product2.Drive_unit__c, UnitPrice
        Product2 pr = new Product2();
        pr.Name='geely atlas base';
        pr.family='geely atlas';
        pr.ProductCode='gab';
        pr.Engine_Capacity__c='';
        pr.Transmission__c='';
        pr.Drive_unit__c='';
        insert pr;
        Product2 pr2 = new Product2();
        pr2.Name='geely coolray base';
        pr.family='geely coolray';
        pr2.ProductCode='gcb';
        pr2.Engine_Capacity__c='';
        pr2.Transmission__c='';
        pr2.Drive_unit__c='';
        insert pr2;


        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = pr.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice2 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = pr2.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice2;

        Pricebook2 pb = new Pricebook2();
        pb.name='Standart Geely Price Book';
        pb.isactive=true;
        insert pb;
        pricebookentry pbe= new pricebookentry();
        pbe.CurrencyIsoCode='BYN';
        pbe.Pricebook2id=pb.id;
        pbe.Product2id=pr.id;
        pbe.Unitprice=1234;
        pbe.isactive = true;
        insert pbe;
        Rates__c rt = new Rates__c();
        rt.Name='BYN';
        rt.Rate__c=1.0;
        insert rt;
        PageReference pageRef = Page.GeelyPrice;
        pageRef.getParameters().put('car','gelly atlas');
        pageRef.getParameters().put('curr','BYN');
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(pbe);// 364/571
        
        PricebookEntryController PbEC = new PricebookEntryController(sc);
        
    }
}
