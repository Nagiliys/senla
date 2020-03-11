public without sharing class AskQuestionController {
    @AuraEnabled(cacheable=true)
    public static List<AutoCenter__c> getAutoCenters(){
        return AutoCenterManager.getAutoCenters();
    }

    @AuraEnabled
    public static void createCase(String firstName, String lastName, String phone, String email, String idCenter, String subject, String description){
        Id empId = EmployeeManager.getFreeEmployeeByIdCenter(idCenter);

        //List<List<sObject>> searchList = [find :email in email fields returning Contact(Id), Lead(Id)];
        List<Contact> cts = [select id from Contact where email=:email limit 1];
        List<Lead> lds = [select id from Lead where email=:email limit 1];

        WrapCase wCase = new WrapCase('New', 'Web', 'BYN', null, null, null, empId, subject, description);

        if(lds.isEmpty()){
            if(cts.isEmpty()){
                WrapLead wLead = new WrapLead(firstName, lastName, 'Client', phone, email, 'Open - Not Contacted', 'BYN');
                Lead ld = LeadManager.createLead(wLead);
                wCase.LeadId=ld.Id;
                CaseManager.createCase(wCase);
            }else{
                wCase.contactId=cts[0].Id;
                CaseManager.createCase(wCase);
            }
        }else{
            wCase.LeadId=lds[0].Id;
            CaseManager.createCase(wCase);
        }
    }
}