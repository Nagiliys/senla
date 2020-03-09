public without sharing class CarsController {
    @AuraEnabled(cacheable=true)
    public static List<AutoCenter__c> getAutoCenters(){
        return AutoCenterManager.getDillerAutoCenters();
    }

    @AuraEnabled(cacheable=true)
    public static List<Product2> getEquipmentByFamily(String family){
        return [select Name, Info__c from Product2 where Family=:family];
    }

    @AuraEnabled
    public static void createOrder(String firstName, String lastName, String phone, String email, String idCenter, String idCar){
        Id empId = EmployeeManager.getFreeEmployeeByIdCenter(idCenter);
        
        Product2 car = [select Name, ProductCode from product2 where id=:idCar];
        Pricebook2 book = [select id from Pricebook2 where name='Standard Geely Price Book' limit 1];
        PricebookEntry PbE = [select UnitPrice from PricebookEntry 
                            where Pricebook2Id=:book.Id and ProductCode=:car.ProductCode and CurrencyIsoCode='BYN'][0];

        //List<List<sObject>> searchList = [find :email in email fields returning Contact(Id, Name), Lead(Id, FirstName, LastName)];
        List<Contact> cts = [select id, Name from Contact where email=:email limit 1];
        List<Lead> lds = [select id, FirstName, LastName from Lead where email=:email limit 1];

        if(lds.isEmpty()){
            if(cts.isEmpty()){
                Lead ld = LeadManager.createLead(firstName, lastName, 'Client', phone, email, 'Open - Not Contacted', 'BYN');
                Id oppId = OpportunityManager.createOpportunity(ld.FirstName+' '+ld.LastName+' '+car.Name, Date.today().addMonths(1), 'Prospecting', ld.Id, null, empId, book.Id, 'BYN');
                CaseManager.createCase('New', 'Web', 'BYN', ld.Id, null, empId, 'Order ' + car.Name, null, oppId);
                OpportunityLineItemManager.createOpportunityLineItem(oppId, 1, Date.today(), car.Id, PbE.UnitPrice);
            }else{
                Id oppId = OpportunityManager.createOpportunity(cts[0].Name+' '+car.Name, Date.today().addMonths(1), 'Prospecting', null, cts[0].Id, empId, book.Id, 'BYN');
                CaseManager.createCase('New', 'Web', 'BYN', null, cts[0].Id, empId, 'Order ' + car.Name, null, oppId);
                OpportunityLineItemManager.createOpportunityLineItem(oppId, 1, Date.today(), car.Id, PbE.UnitPrice);
            }
        }else{
            Id oppId = OpportunityManager.createOpportunity(lds[0].FirstName+' '+lds[0].LastName+' '+car.Name, Date.today().addMonths(1), 'Prospecting', lds[0].Id, null, empId, book.Id, 'BYN');
            CaseManager.createCase('New', 'Web', 'BYN', lds[0].Id, null, empId, 'Order ' + car.Name, null, oppId);
            OpportunityLineItemManager.createOpportunityLineItem(oppId, 1, Date.today(), car.Id, PbE.UnitPrice);
        }
    }
}
