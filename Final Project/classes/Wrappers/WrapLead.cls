public class WrapLead {
    public String FirstName { get; set; }
    public String LastName { get; set; }
    public String Company { get; set; }
    public String Phone { get; set; }
    public String email { get; set; }
    public String Status { get; set; }
    public String CurrencyIsoCode { get; set; }
    
    public WrapLead(String FirstName, String LastName, String Company, String Phone ,String email, String Status, String CurrencyIsoCode) {
        this.FirstName = FirstName;
        this.LastName = LastName;
        this.Company = Company;
        this.Phone = Phone;
        this.email = email;
        this.Status = Status;
        this.CurrencyIsoCode = CurrencyIsoCode;
    }
}
