public class WrapOpportunity {
    public String Name { get; set; }
    public Date CloseDate { get; set; }
    public String StageName { get; set; }
    public String leadId { get; set; }
    public String contactId { get; set; }
    public String employeeId { get; set; }
    public String Pricebook2Id { get; set; }
    public String CurrencyIsoCode { get; set; }

    public WrapOpportunity(String Name, Date CloseDate, String StageName, String LeadId, String ContactId, String employeeId, String Pricebook2Id, String CurrencyIsoCode) {
        this.Name = Name;
        this.CloseDate = CloseDate;
        this.StageName = StageName;
        this.leadId = leadId;
        this.contactId = contactId;
        this.employeeId = employeeId;
        this.Pricebook2Id = Pricebook2Id;
        this.CurrencyIsoCode=CurrencyIsoCode;
    }
}
