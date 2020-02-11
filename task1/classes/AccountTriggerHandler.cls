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

                    
                    ct.AccountId=acc.id;
                    insert ct;
            }
        }
    }

}