@isTest
public with sharing class CarsController_Test {
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

        Product2 pr = new Product2(
            Name='geely atlas base',
            family='geely atlas',
            ProductCode='gab'
        );
        insert pr;
        Product2 pr2 = new Product2(
            Name='geely coolray base',
            family='geely coolray',
            ProductCode='gcb'
        );
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

        Pricebook2 pb = new Pricebook2(
            name='Standard Geely Price Book',
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
    }

    @isTest
    public static void testGetAutoCenters_1(){
        Test.starttest();
        List<AutoCenter__c> ac = CarsController.getAutoCenters();
        Test.stoptest();

        system.assertEquals(1, ac.size());
    }
    
    @isTest
    public static void testGetEquipmentByFamily_1(){
        Test.starttest();
        List<Product2> pr = CarsController.getEquipmentByFamily('geely atlas');
        Test.stoptest();

        system.assertEquals(1, pr.size());
    }

    @isTest
    public static void testCreateOrder_1(){//create lead
        String firstName = '1st'; 
        String lastName='8th';
        String phone = '123456';
        String email = 'a@b.c';
        AutoCenter__c center = [select Id from AutoCenter__c limit 1];
        Product2 car = [select id from Product2 limit 1];
        String idCenter = center.Id;
        String idCar = car.Id;

        Test.starttest();
        CarsController.createOrder(firstName, lastName, phone, email, idCenter, idCar);
        Test.stoptest();

        list<Lead> lds = [select id, email from Lead];
        List<Case> cases = [select Lead__c from case];
        system.assertEquals(1, cases.size());
        system.assertEquals(1, lds.size());
        system.assertEquals(lds[0].Id, cases[0].Lead__c);
    }

    @isTest
    public static void testCreateOrder_2(){//update lead
        String firstName = '1st'; 
        String lastName='8th';
        String phone = '123456';
        String email = 'a@b.c';
        AutoCenter__c center = [select Id from AutoCenter__c limit 1];
        Product2 car = [select id from Product2 limit 1];
        String idCenter = center.Id;
        String idCar = car.Id;
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
        CarsController.createOrder(firstName, lastName, phone, email, idCenter, idCar);
        Test.stoptest();

        List<Case> cases = [select Lead__c from case];
        system.assertEquals(1, cases.size());
        system.assertEquals(ld.Id, cases[0].Lead__c);
    }

    @isTest
    public static void testCreateOrder_3(){//update contact
        String firstName = '1st'; 
        String lastName='8th';
        String phone = '123456';
        String email = 'a@b.c';
        AutoCenter__c center = [select Id from AutoCenter__c limit 1];
        Product2 car = [select id from Product2 limit 1];
        String idCenter = center.Id;
        String idCar = car.Id;
        Contact ct = new Contact(
            firstName=firstName,
            lastName=lastName,
            phone=phone,
            email=email
        );
        insert ct;

        Test.starttest();
        CarsController.createOrder(firstName, lastName, phone, email, idCenter, idCar);
        Test.stoptest();

        List<Case> cases = [select ContactId from case];
        system.assertEquals(1, cases.size());
        system.assertEquals(ct.Id, cases[0].ContactId);
    }
}
