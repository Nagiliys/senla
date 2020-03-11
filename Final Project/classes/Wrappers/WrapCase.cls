public class WrapCase {
    public String Status { get; set; }
    public String Origin { get; set; }
    public String CurrencyIsoCode { get; set; }
    public String leadId { get; set; }
    public String contactId { get; set; }
    public String opportunityId { get; set; }
    public String employeeId { get; set; }
    public String Subject { get; set; }
    public String Description { get; set; }
    
    public WrapCase(String status, String Origin, String CurrencyIsoCode, String leadId ,String contactId, String opportunityId, String employeeId, String Subject, String Description) {
        this.status = status;
        this.Origin = Origin;
        this.CurrencyIsoCode = CurrencyIsoCode;
        this.leadId = leadId;
        this.contactId = contactId;
        this.opportunityId = opportunityId;
        this.employeeId = employeeId;
        this.Subject = Subject;
        this.Description=Description;
    }
}
