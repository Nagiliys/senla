public without sharing class CaseManager {
    public static Id createCase(String Status, String Origin, String CurrencyIsoCode,Id ld, Id ct, Id empId, String Subject, String Description, ID oppId){
        Case cs = new Case(
            Status=Status,
            Origin=Origin,
            CurrencyIsoCode=CurrencyIsoCode,
            employee__c=empId,
            ContactId=ct,
            Lead__c=ld,
            Subject=Subject,
            Description=Description,
            Opportunity__c=oppId
        );
        insert cs;
        return cs.Id;
    }
}
