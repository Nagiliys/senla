public class AccountTriggerHandler extends TriggerHandler{
    protected override void beforeInsert(){
        for(Account acc : (List<Account>)trigger.new){
            if(acc.type=='Vip'){
                    Contact ct = new Contact();

                    if(acc.Name.length()>3){
                        ct.Firstname=acc.Name.substring(0,3);
                        ct.LastName=acc.name.substring(3);
                    }else{
                        ct.Lastname=acc.Name;
                    }

                    Date today = Date.today();
                    Date nextNewYear = Date.newInstance(today.year(), 12, 31);
                    ct.Days_before_new_year__c = today.daysBetween(nextNewYear);
                    ct.AccountId=acc.id;
                    insert ct;
            }
            acc.countContacts__c= [select count() from Contact where accountId=:acc.id];
        }
    }

    protected override void beforeUpdate(){
        for(Account acc : (List<Account>)trigger.new){
            acc.countContacts__c= [select count() from Contact where accountId=:acc.id];
        }
    }

}