public without sharing class LeadManager {
    public static Lead createLead(WrapLead wLead){
        Lead ld = new Lead(
            FirstName=wLead.FirstName,
            LastName=wLead.LastName,
            Company=wLead.Company,
            Phone=wLead.Phone,
            Email=wLead.email,
            Status=wLead.Status,
            CurrencyIsoCode=wLead.CurrencyIsoCode
        );
        insert ld;
        return ld;
    }
}
