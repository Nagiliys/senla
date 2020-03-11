public class CaseTriggerHandler extends TriggerHandler{
    protected override void beforeInsert(){
        List<String> emails = new List<String>();
        for(Case cs : (List<Case>)trigger.new){
            if(cs.SuppliedName!=null && cs.SuppliedEmail!=null){
                emails.add(cs.SuppliedEmail);
            }
        }
        if(emails.isEmpty()){
            return;
        }
        Lead lead;
        List<Lead> newLeads = new List<Lead>();
        String idEmp = EmployeeManager.getFreeEmployee();
        List<Lead> leads = [select Id, email from Lead where email in :emails];
        List<Contact> contacts = [select Id, email from Contact where email in :emails];
        boolean isInsert = false;
        for(Case cs : (List<Case>)trigger.new){
            isInsert = false;
            if(cs.SuppliedName!=null && cs.SuppliedEmail!=null){
                for(Lead ld : leads){
                    if(cs.SuppliedEmail==ld.email){
                        cs.Lead__c=ld.Id;
                        isInsert=true;
                        break;
                    }
                }
                if(isInsert){break;}
                for(Contact ct : contacts){
                    if(cs.SuppliedEmail==ct.email){
                        cs.ContactId=ct.Id;
                        isInsert=true;
                        break;
                    }
                }
                if(isInsert){break;}
                lead = new Lead(
                    LastName = cs.SuppliedName,
                    company = 'Client',
                    email = cs.SuppliedEmail
                );
                newLeads.add(lead);
            }
        }
        insert newLeads;
        for(Case cs : (List<Case>)trigger.new){
            if(cs.SuppliedName!=null && cs.SuppliedEmail!=null){
                for(Lead ld : newLeads){
                    if(cs.SuppliedEmail==ld.email){
                        cs.Lead__c=ld.Id;
                        break;
                    }
                }
            }
        }
    }
}
