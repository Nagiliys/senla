public without sharing class TestDriveController {
    @AuraEnabled(cacheable=true)
    public static List<AutoCenter__c> getAutoCenters(){
        return AutoCenterManager.getDillerAutoCenters();
    }

    @AuraEnabled
    public static void createCase(String firstName, String lastName, String phone, String email, String idCenter){
        Id empId = EmployeeManager.getFreeEmployeeByIdCenter(idCenter);

        //List<List<sObject>> searchList = [find :email in email fields returning Contact(Id), Lead(Id)];
        List<Contact> cts = [select id from Contact where email=:email limit 1];
        List<Lead> lds = [select id from Lead where email=:email limit 1];
        system.debug('contacts: '+cts);
        system.debug('leads: '+lds);

        if(lds.isEmpty()){
            if(cts.isEmpty()){
                Lead ld = LeadManager.createLead(firstName, lastName, 'Client', phone, email, 'Open - Not Contacted', 'BYN');
                CaseManager.createCase('New', 'Web', 'BYN', ld.Id, null, empId, 'Test Drive', null, null);
            }else{
                CaseManager.createCase('New', 'Web', 'BYN', null, cts[0].Id, empId, 'Test Drive', null, null);
            }
        }else{
            CaseManager.createCase('New', 'Web', 'BYN', lds[0].Id, null, empId, 'Test Drive', null, null);
        }
    }
}
