public class WrapOpportunityLineItem {
    public String opportunityId { get; set; }
    public Integer Quantity { get; set; }
    public Date ServiceDate { get; set; }
    public String Product2Id { get; set; }
    public Decimal UnitPrice { get; set; }
    
    public WrapOpportunityLineItem(String opportunityId, Integer Quantity, Date ServiceDate, String Product2Id, Decimal UnitPrice) {
        this.opportunityId = opportunityId;
        this.Quantity = Quantity;
        this.ServiceDate = ServiceDate;
        this.Product2Id = Product2Id;
        this.UnitPrice=UnitPrice;
    }
}
