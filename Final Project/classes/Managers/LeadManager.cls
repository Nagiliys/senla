public without sharing class LeadManager {
    public static Lead createLead(String FirstName, String LastName, String Company, String Phone, String email, String Status, String CurrencyIsoCode){
        Lead ld = new Lead(
            FirstName=FirstName,
            LastName=LastName,
            Company=Company,
            Phone=Phone,
            Email=email,
            Status=Status,
            CurrencyIsoCode=CurrencyIsoCode
        );
        insert ld;
        return ld;
    }
}
