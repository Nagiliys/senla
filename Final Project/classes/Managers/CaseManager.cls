public without sharing class CaseManager {
    public static Id createCase(WrapCase wCase){
        Case cs = new Case(
            Status=wCase.Status,
            Origin=wCase.Origin,
            CurrencyIsoCode=wCase.CurrencyIsoCode,
            employee__c=wCase.employeeId,
            ContactId=wCase.contactId,
            Lead__c=wCase.leadId,
            Subject=wCase.Subject,
            Description=wCase.Description,
            Opportunity__c=wCase.opportunityId
        );
        insert cs;
        return cs.Id;
    }
}
