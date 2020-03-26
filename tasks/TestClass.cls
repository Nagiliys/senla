public class TestClass {
    public static void copyItems(Id sourceId, Id targetId){
	List<FeedItem> items = [SELECT id, (select FieldName, OldValue, NewValue from FeedTrackedChanges) FROM FeedItem where Type='TrackedChange' and parentId=:sourceId];
        List<FeedItem> clonedItems = new List<FeedItem>();
        FeedItem clonedItem;
        for(FeedItem item : items){
            clonedItem = new FeedItem(
                ParentId=targetId,
                Type='TextPost'
            );
            for(FeedTrackedChange feed: item.FeedTrackedChanges){
                clonedItem.body+=feed.FieldName+'\nfrom '+feed.NewValue+' to '+feed.OldValue+'\n';
            }
            clonedItems.add(clonedItem);
        }
        insert clonedItems;
    }
}