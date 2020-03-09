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

        if(lds.isEmpty()){
            if(cts.isEmpty()){
                Lead ld = LeadManager.createLead(firstName, lastName, 'Client', phone, email, 'Open - Not Contacted', 'BYN');
                CaseManager.createCase('New', 'Web', 'BYN', ld.Id, null, empId, subject, description, null);
            }else{
                CaseManager.createCase('New', 'Web', 'BYN', null, cts[0].Id, empId, subject, description, null);
            }
        }else{
            CaseManager.createCase('New', 'Web', 'BYN', lds[0].Id, null, empId, subject, description, null);
        }
    }
}