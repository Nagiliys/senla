public without sharing class OpportunityManager {
    public static Id createOpportunity(String Name, Date CloseDate, String StageName, Id LeadId, Id ContactId, Id emp, Id Pricebook2Id, String CurrencyIsoCode){
        Opportunity opp = new Opportunity(
            Name=Name,
            CloseDate=CloseDate,
            StageName=StageName,
            Lead__c=leadId,
            Contact__c=ContactId,
            employee__c=emp,
            Pricebook2Id=Pricebook2Id,
            CurrencyIsoCode=CurrencyIsoCode
        );
        insert opp;
        return opp.Id;
    }
}
