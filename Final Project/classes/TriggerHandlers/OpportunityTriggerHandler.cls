public class OpportunityTriggerHandler extends TriggerHandler{
    protected override void beforeUpdate(){//trigger.newMap.keySet()
                ClosedWon();
                ClosedLost();
    }

    private void ClosedLost(){
        for(Opportunity opp : (List<Opportunity>)trigger.new){
            if(opp.StageName=='Closed Lost'){
                List<Case> cases = [select status from Case where Opportunity__c=:opp.id];
                for(Case cs : cases){
                    cs.status='Closed';
                }
                update cases;
            }
        }
    }

    private void ClosedWon(){
        String CurrencyIsoCode = 'BYN';
        List<Opportunity> opps;
        List<Case> casesOpp;
        List<Case> casesLead;
        Lead ld;
        Contact ct;
        Set<Id> ids = trigger.newMap.keySet();
        for(Opportunity opp : (List<Opportunity>)trigger.new){
            if(opp.StageName=='Closed Won' && opp.Lead__c!=null && opp.Contact__c==null){
                
                ld = [select id, firstname, lastname, email, phone from lead where id=:opp.Lead__c];
                opps = [select id, Contact__c, Lead__c from Opportunity where lead__c=:ld.id and id not in :ids];
                casesOpp = [select id, ContactId, Lead__c, status from Case where Opportunity__c=:opp.id];
                casesLead = [select id, ContactId, Lead__c from Case where Lead__c=:ld.Id];
                ct = new Contact();
                ct.firstname=ld.firstname;
                ct.lastname=ld.lastname;
                ct.email=ld.email;
                ct.phone=ld.phone;
                ct.CurrencyIsoCode = CurrencyIsoCode;
                delete ld;
                insert ct;
                sendEmail(ct);
                opp.Lead__c=null;
                opp.Contact__c=ct.Id;
                for(Opportunity opport : opps){
                    opport.Lead__c=null;
                    opport.Contact__c=ct.Id;
                }
                update opps;
                for(Case cs : casesOpp){
                    cs.Lead__c=null;
                    cs.ContactId=ct.Id;
                    cs.status='Closed';
                }
                update casesOpp;
                for(Case cs : casesLead){
                    cs.Lead__c=null;
                    cs.ContactId=ct.Id;
                }
                update casesLead;
            }else{
                if(opp.StageName=='Closed Won' && opp.Lead__c==null && opp.Contact__c!=null){
                    casesOpp = [select id, ContactId, Lead__c, status from Case where Opportunity__c=:opp.id];
                    for(Case cs : casesOpp){
                        cs.status='Closed';
                    }
                    update casesOpp;
                    ct = [select email from Contact where id=:opp.Contact__c];
                    sendEmail(ct);
                }
            }
        }
    }
    private void sendEmail(Contact ct){
        Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage();
        EmailTemplate template  = [Select id from Emailtemplate where Name =: 'Feedback' Limit 1];
        mail.setTemplateId(template.Id);
        mail.setTargetObjectId(ct.Id);
        for (Messaging.SendEmailResult r: Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail})){
            System.debug('email success\n'+r.isSuccess());
        }
    }
}
