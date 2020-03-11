public without sharing class OpportunityManager {
    public static Id createOpportunity(WrapOpportunity wOpp){
        Opportunity opp = new Opportunity(
            Name=wOpp.Name,
            CloseDate=wOpp.CloseDate,
            StageName=wOpp.StageName,
            Lead__c=wOpp.leadId,
            Contact__c=wOpp.ContactId,
            employee__c=wOpp.employeeId,
            Pricebook2Id=wOpp.Pricebook2Id,
            CurrencyIsoCode=wOpp.CurrencyIsoCode
        );
        insert opp;
        return opp.Id;
    }
}
