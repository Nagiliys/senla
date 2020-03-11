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

        WrapCase wCase = new WrapCase('New', 'Web', 'BYN', null, null, null, empId, 'Order ' + car.Name, null);
        WrapOpportunity wOpp = new WrapOpportunity(null, Date.today().addMonths(1), 'Prospecting', null, null, empId, book.Id, 'BYN');
        WrapOpportunityLineItem wOppLI = new WrapOpportunityLineItem(null, 1,  Date.today(), car.Id, PbE.UnitPrice);
        if(lds.isEmpty()){
            if(cts.isEmpty()){
                WrapLead wLead = new WrapLead(firstName, lastName, 'Client', phone, email, 'Open - Not Contacted', 'BYN');
                Lead ld = LeadManager.createLead(wLead);
                wOpp.Name = ld.FirstName+' '+ld.LastName+' '+car.Name;
                wOpp.leadId = ld.Id;
                Id oppId = OpportunityManager.createOpportunity(wOpp);
                wCase.leadId = ld.Id;
                wCase.opportunityId = oppId;
                CaseManager.createCase(wCase);
                wOppLI.OpportunityId=oppId;
                OpportunityLineItemManager.createOpportunityLineItem(wOppLI);
            }else{
                wOpp.Name = cts[0].Name+' '+car.Name;
                wOpp.contactId = cts[0].Id;
                Id oppId = OpportunityManager.createOpportunity(wOpp);
                wCase.contactId=cts[0].Id;
                wCase.opportunityId = oppId;
                CaseManager.createCase(wCase);
                wOppLI.OpportunityId=oppId;
                OpportunityLineItemManager.createOpportunityLineItem(wOppLI);
            }
        }else{
            wOpp.Name = lds[0].FirstName+' '+lds[0].LastName+' '+car.Name;
            wOpp.leadId = lds[0].Id;
            Id oppId = OpportunityManager.createOpportunity(wOpp);
            wCase.leadId=lds[0].Id;
            wCase.opportunityId = oppId;
            CaseManager.createCase(wCase);
            wOppLI.OpportunityId=oppId;
            OpportunityLineItemManager.createOpportunityLineItem(wOppLI);
        }
    }
}
