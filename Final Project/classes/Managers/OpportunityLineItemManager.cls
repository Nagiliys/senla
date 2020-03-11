public without sharing class OpportunityLineItemManager {
    public static Id createOpportunityLineItem(WrapOpportunityLineItem wOppLI){
        OpportunityLineItem item = new OpportunityLineItem(
            OpportunityId=wOppLI.opportunityId,
            Quantity=wOppLI.Quantity,
            ServiceDate=wOppLI.ServiceDate,
            Product2Id=wOppLI.Product2Id,
            UnitPrice=wOppLI.UnitPrice
        );
        insert item;
        return item.id;
    }
}
