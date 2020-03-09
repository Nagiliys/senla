public class CaseTriggerHandler extends TriggerHandler{
    protected override void beforeInsert(){
        String email;
        String name;
        Lead[] lds;
        Lead ld;
        Contact[] cts;
        Contact ct;
        List<employee__c> emp;
        Employee__c target;
        for(Case cs : (List<Case>)trigger.new){
            if(cs.SuppliedName!=null && cs.SuppliedEmail!=null){
                emp = [select id, (select id from cases__r where Status!='Closed') from employee__c];
                target = emp[0];
                integer min = emp[0].cases__r.size()+1;
                for(employee__c e : emp){
                    if(min > e.cases__r.size()){
                        min = e.cases__r.size();
                        target = e;
                    }
                }                
                name = cs.SuppliedName;
                email=cs.SuppliedEmail;
                //emp?
                cts = [select id from Contact where email=:email];
                if(cts.size()>0){
                    ct=cts[0];
                    cs.ContactId=ct.Id;
                    cs.employee__c=target.Id;
                }else{
                    lds = [select id from Lead where email=:email];
                    if(lds.size()>0){
                        ld=lds[0];
                        cs.employee__c=target.Id;
                        cs.Lead__c=ld.Id;
                    }else{
                        ld=new Lead();
                        ld.LastName=name;
                        ld.email=email;
                        ld.company='client';
                        ld.status='Open - Not Contacted';
                        insert ld;
                        cs.employee__c=target.Id;
                        cs.Lead__c=ld.Id;
                    }
                }
            }
        }
    }
}
