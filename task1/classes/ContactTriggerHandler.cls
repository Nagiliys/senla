public class ContactTriggerHandler extends TriggerHandler{
    protected override void afterInsert(){
        UpdateCountContacts();
    }
    protected override void afterUpdate(){
        UpdateCountContacts();
    }
    protected override void afterDelete(){
        UpdateCountContacts();
    }
    protected override void afterUnDelete(){
        UpdateCountContacts();
    }
    public static void UpdateCountContacts(){
        Set<Id> ids = new Set<Id>();
        for(Contact ct : (List<Contact>)trigger.new){
            ids.add(ct.AccountId);
        }
        for(Contact ct : (List<Contact>)trigger.old){
            ids.add(ct.AccountId);
        }
        List<Account> accs = [select Id, countContacts__c from Account where id in :Ids];
        for(Account acc : accs){
            acc.countContacts__c = [select count() from Contact where accountId=:acc.id];
        }
    }
}
