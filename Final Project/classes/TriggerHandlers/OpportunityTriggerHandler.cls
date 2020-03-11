public class OpportunityTriggerHandler extends TriggerHandler{
    protected override void beforeUpdate(){//trigger.newMap.keySet()
                ClosedWon();
                ClosedLost();
    }

    private void ClosedLost(){
        List<Id> oppsIds = new List<Id>();
        for(Opportunity opp : (List<Opportunity>)trigger.new){
            if(opp.StageName=='Closed Lost'){
                oppsIds.add(opp.Id);
            }
        }
        List<Case> cases = [select status from Case where Opportunity__c in :oppsIds];
        for(Case cs : cases){
            cs.status='Closed';
        }
        update cases;
    }

    private void ClosedWon(){
        String CurrencyIsoCode = 'BYN';
        List<Id> ldsId = new List<Id>();
        List<Id> ctsId = new List<Id>();
        Map<String, Opportunity> oppsLeadId = new Map<String, Opportunity>();
        Map<String, Case> casesLeadId = new Map<String, Case>();
        Map<String, Contact> ctsLeadId = new Map<String, Contact>();
        List<Id> oppsIdToUpdateCases = new List<Id>();
        List<Id> oppsIdWithLead = new List<Id>();
        for(Opportunity opp : (List<Opportunity>)trigger.new){
            if(opp.StageName=='Closed Won' && opp.Lead__c!=null && opp.Contact__c==null){
                ldsId.add(opp.Lead__c);
                oppsLeadId.put((String)opp.Lead__c, opp);
                oppsIdToUpdateCases.add(opp.Id);
            }else{
                if(opp.StageName=='Closed Won' && opp.Lead__c==null && opp.Contact__c!=null){
                    ctsId.add(opp.Contact__c);
                    oppsIdToUpdateCases.add(opp.Id);
                }
            }
        }
        List<Case> OppCase = [select status from case where Opportunity__c in :oppsIdToUpdateCases];
        for(Case cs : OppCase){
            cs.status='Closed';
        }
        update OppCase;
        List<lead> leads = [select firstname, lastname, email, phone from Lead where Id in :ldsId];
        List<Case> leadCases = [select ContactId, Lead__c from case where Lead__c in :ldsId];
        Contact contact;
        List<Contact> newContacts = new List<Contact>();
        for(id ldId : ldsId){
            for(case cs : leadCases){
                if(cs.Lead__c==ldId){
                    casesLeadId.put((String)ldId, cs);
                    break;
                }
            }
            for(Lead ld : leads){
                if(ld.id==ldId){
                    contact = new Contact(
                        firstname=ld.firstname,
                        lastname=ld.lastname,
                        email=ld.email,
                        phone=ld.phone,
                        CurrencyIsoCode=CurrencyIsoCode
                    );
                    newContacts.add(contact);
                    ctsLeadId.put(ldId, contact);
                }
            }
        }
        delete leads;
        insert newContacts;
        Opportunity opp;
        Case cs;
        List<Case> cases = new List<Case>();
        for(id ldId : ldsId){
            contact = ctsLeadId.get(ldId);
            ctsId.add(contact.Id);
            opp = oppsLeadId.get(ldId);
            cs = casesLeadId.get(ldId);
            opp.Lead__c=null;
            opp.Contact__c = contact.Id;
            cs.Lead__c=null;
            cs.ContactId = contact.Id;
            cases.add(cs);
        }
        update cases;
        if(!ctsId.isEmpty()){
            sendEmail(ctsId);
        }   
    }

    private void sendEmail(List<Id> ctsId){
        EmailTemplate template  = [Select id from Emailtemplate where Name =: 'Feedback' Limit 1];
        Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
        mail.setTargetObjectIds(ctsId);
        mail.setSenderDisplayName('System Admin');
        mail.setTemplateId(template.id);
        Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
    }
}