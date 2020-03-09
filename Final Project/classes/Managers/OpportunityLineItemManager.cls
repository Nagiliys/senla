public without sharing class OpportunityLineItemManager {
    public static Id createOpportunityLineItem(Id oppId, Integer Quantity, Date ServiceDate, Id Product2Id, Decimal UnitPrice){
        OpportunityLineItem item = new OpportunityLineItem(
            OpportunityId=oppId,
            Quantity=Quantity,
            ServiceDate=ServiceDate,
            Product2Id=Product2Id,
            UnitPrice=UnitPrice
        );
        insert item;
        return item.id;
    }
}
