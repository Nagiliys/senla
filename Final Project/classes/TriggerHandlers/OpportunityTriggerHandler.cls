public class OpportunityTriggerHandler extends TriggerHandler{
    protected override void afterUpdate(){
        ClosedWon();
        ClosedLost();
    }
    private void ClosedLost(){
        List<Opportunity> opps = getClosedLost();
        if(opps.size()!=0){
            List<Id> oppsIds = new List<Id>();
            for(Opportunity opp : opps){
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
    }
    private List<Opportunity> getClosedLost(){
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity old;
        Opportunity neww;
        for(integer i=0; i<trigger.new.size(); i++){
            neww  = (Opportunity)trigger.new[i];
            old = (Opportunity)trigger.old[i];
            if(neww.StageName=='Closed Lost' &&old.StageName!='Closed Lost' ){
                opps.add((Opportunity)trigger.new[i]);
            }
        }
        return opps;
    }
    private void ClosedWon(){
        List<Opportunity> opps = getClosedWon();
        if(opps.size()!=0){
            OpportunitiesToMap(opps);
        }
    }
    private List<Opportunity> getClosedWon(){
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity old;
        Opportunity neww;
       
        for(integer i=0; i<trigger.new.size(); i++){
            neww  = (Opportunity)trigger.new[i];
            old = (Opportunity)trigger.old[i];
            if(neww.StageName=='Closed Won' &&old.StageName!='Closed Won' ){
                opps.add((Opportunity)trigger.new[i]);
            }
        }
        return opps;
    }
    private void OpportunitiesToMap(List<Opportunity> opps){
        List<Id> ctsId = new List<Id>();
        List<Id> oppsIdToUpdateCases = new List<Id>();
        Map<String, Opportunity> oppsLeadId = new Map<String, Opportunity>();
       
        for(Opportunity opp : opps){
            if(opp.StageName=='Closed Won' && opp.Lead__c!=null && opp.Contact__c==null){
                oppsLeadId.put((String)opp.Lead__c, opp);
                oppsIdToUpdateCases.add(opp.Id);
            }else{
                if(opp.StageName=='Closed Won' && opp.Lead__c==null && opp.Contact__c!=null){
                    ctsId.add(opp.Contact__c);
                    oppsIdToUpdateCases.add(opp.Id);
                }
            }
        }
        CloseCases(oppsIdToUpdateCases);
        convertLeadToContacts(oppsLeadId);

        if(!ctsId.isEmpty()){
            sendEmail(ctsId);
        }
    }
    private void CloseCases(List<Id> oppsIdToUpdateCases){
        List<Case> OppCase = [select status from case where Opportunity__c in :oppsIdToUpdateCases];
        for(Case cs : OppCase){
            cs.status='Closed';
        }
        update OppCase;
    }
    private void convertLeadToContacts(Map<String, Opportunity> oppsLeadId){
        Set<String> ldsId = oppsLeadId.keySet();//(List<String>)
        List<lead> leads = [select firstname, lastname, email, phone from Lead where Id in :ldsId];
        List<Case> leadCases = [select ContactId, Lead__c from case where Lead__c in :ldsId];
        Contact contact;
        List<Contact> newContacts = new List<Contact>();
        Map<String, Case> casesLeadId = new Map<String, Case>();
        Map<String, Contact> ctsLeadId = new Map<String, Contact>();
        for(String ldId : ldsId){//lead case to map
            for(case cs : leadCases){
                if(cs.Lead__c==ldId){
                    casesLeadId.put(ldId, cs);
                    break;
                }
            }
            for(Lead ld : leads){
                if(ld.id==ldId){//new contact to map & list new contact
                    contact = new Contact(
                        firstname=ld.firstname,
                        lastname=ld.lastname,
                        email=ld.email,
                        phone=ld.phone,
                        CurrencyIsoCode='BYN'
                    );
                    newContacts.add(contact);
                    ctsLeadId.put(ldId, contact);
                }
            }
        }
        delete leads;
        insert newContacts;
        updateOpportunitiesAndCases(ldsId, oppsLeadId, casesLeadId, ctsLeadId);
    }
    private void updateOpportunitiesAndCases(Set<String> ldsId, Map<String, Opportunity> oppsLeadId, Map<String, Case> casesLeadId,  Map<String, Contact> ctsLeadId){
        List<Opportunity> AllOpps = [select Lead__c, Contact__c from Opportunity];
        List<Opportunity> oppsToUpdate = new  List<Opportunity>();
        Opportunity opport;//opp read only
        Case cs;
        Contact contact;
        List<String> ctsId = new List<Id>();
        List<Case> cases = new List<Case>();
        List<Opportunity> opps = new List<Opportunity>();
        for(String ldId : ldsId){
            contact = ctsLeadId.get(ldId);
            opport = oppsLeadId.get(ldId);
            ctsId.add(contact.Id);
            cs = casesLeadId.get(ldId);
            cs.Lead__c=null;
            cs.ContactId = contact.Id;
            cases.add(cs);
            for(Opportunity opp : AllOpps){
                if(opp.Id==opport.Id){
                    opp.Lead__c=null;
                    opp.Contact__c = contact.Id;
                    oppsToUpdate.add(opp);
                    break;
                }
            }
        }
        update cases;
        update oppsToUpdate;
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