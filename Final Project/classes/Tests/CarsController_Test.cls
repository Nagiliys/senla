@isTest
public with sharing class CarsController_Test {
    @TestSetup
    public static void setup(){
        TriggersSwitch__c tr = new TriggersSwitch__c();
        tr.Name='opportunityTrigger';
        tr.isTriggerActive__c=true;
        insert tr;
        TriggersSwitch__c trcase = new TriggersSwitch__c();
        trcase.Name='caseTrigger';
        trcase.isTriggerActive__c=true;
        insert trcase;
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
        CarsController.Wrapper wrapper = getWrapper();

        Test.starttest();
        CarsController.createOrder(wrapper);
        Test.stoptest();

        list<Lead> lds = [select id, email from Lead];
        List<Case> cases = [select Lead__c from case];
        system.assertEquals(1, cases.size());
        system.assertEquals(1, lds.size());
        system.assertEquals(lds[0].Id, cases[0].Lead__c);
    }

    @isTest
    public static void testCreateOrder_2(){//update lead
        CarsController.Wrapper wrapper = getWrapper();
        Lead ld = new Lead(
            firstName=wrapper.firstName,
            lastName=wrapper.lastName,
            phone=wrapper.phone,
            email=wrapper.email,
            company='Client',
            status='Open Not Contacted'
        );
        insert ld;

        Test.starttest();
        CarsController.createOrder(wrapper);
        Test.stoptest();

        List<Case> cases = [select Lead__c from case];
        system.assertEquals(1, cases.size());
        system.assertEquals(ld.Id, cases[0].Lead__c);
    }

    @isTest
    public static void testCreateOrder_3(){//update contact
        CarsController.Wrapper wrapper = getWrapper();
        Contact ct = new Contact(
            firstName=wrapper.firstName,
            lastName=wrapper.lastName,
            phone=wrapper.phone,
            email=wrapper.email
        );
        insert ct;

        Test.starttest();
        CarsController.createOrder(wrapper);
        Test.stoptest();

        List<Case> cases = [select ContactId from case];
        system.assertEquals(1, cases.size());
        system.assertEquals(ct.Id, cases[0].ContactId);
    }
    private static CarsController.Wrapper getWrapper(){
        CarsController.Wrapper wrapper = CarsController.getWrapper();
        wrapper.firstName = 'firstName';
        wrapper.lastName = 'lastName';
        wrapper.phone = '+1(800)12345';
        wrapper.email = 'a@b.c';
        AutoCenter__c center = [select Id from AutoCenter__c limit 1];
        wrapper.idCenter = center.id;
        Product2 car = [select id from Product2 limit 1];
        wrapper.idCar = car.Id;
        return wrapper;
    }
}
