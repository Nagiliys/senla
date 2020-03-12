public without sharing class CarsController {
    @AuraEnabled(cacheable=true)
    public static List<AutoCenter__c> getAutoCenters(){
        return AutoCenterManager.getDillerAutoCenters();
    }

    @AuraEnabled(cacheable=true)
    public static List<Product2> getEquipmentByFamily(String family){
        return [select Name, Info__c from Product2 where Family=:family];
    }
    @AuraEnabled(cacheable=true)
    public static Wrapper getWrapper(){
        return new Wrapper();
    }
    @AuraEnabled
    public static void createOrder(Wrapper wrapper){
        Id empId = EmployeeManager.getFreeEmployeeByIdCenter(wrapper.idCenter);
        Product2 car = [select Name, ProductCode from product2 where id=:wrapper.idCar];
        Pricebook2 book = [select id from Pricebook2 where name='Standard Geely Price Book' limit 1];
        PricebookEntry PbE = [select UnitPrice from PricebookEntry where Pricebook2Id=:book.Id and ProductCode=:car.ProductCode and CurrencyIsoCode='BYN'][0];
        WrapCase wCase = new WrapCase('New', 'Web', 'BYN', null, null, null, empId, 'Order ' + car.Name, null);
        WrapOpportunity wOpp = new WrapOpportunity(null, Date.today().addMonths(1), 'Prospecting', null, null, empId, book.Id, 'BYN');
        WrapOpportunityLineItem wOppLI = new WrapOpportunityLineItem(null, 1,  Date.today(), car.Id, PbE.UnitPrice);
        List<Lead> lds = [select id, FirstName, LastName from Lead where email=:wrapper.email limit 1];
        if(lds.isEmpty()){
            List<Contact> cts = [select id, Name from Contact where email=:wrapper.email limit 1];
            if(cts.isEmpty()){
                WrapLead wLead = new WrapLead(wrapper.firstName, wrapper.lastName, 'Client', wrapper.phone, wrapper.email, 'Open - Not Contacted', 'BYN');
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
  
    public class Wrapper{
        @AuraEnabled public String firstName {get; set;}
        @AuraEnabled public String lastName {get; set;}
        @AuraEnabled public String phone {get; set;}
        @AuraEnabled public String email {get; set;}
        @AuraEnabled public String idCenter {get; set;}
        @AuraEnabled public String idCar {get; set;}
    }
}
