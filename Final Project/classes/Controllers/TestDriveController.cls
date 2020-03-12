public without sharing class TestDriveController {
    @AuraEnabled(cacheable=true)
    public static List<AutoCenter__c> getAutoCenters(){
        return AutoCenterManager.getDillerAutoCenters();
    }
    @AuraEnabled(cacheable=true)
    public static Wrapper getWrapper(){
        return new Wrapper();
    }
    @AuraEnabled
    public static void createCase(Wrapper wrapper){
        Id empId = EmployeeManager.getFreeEmployeeByIdCenter(wrapper.idCenter);
        WrapCase wCase = new WrapCase('New', 'Web', 'BYN', null, null, null, empId, 'TestDrive', null);
        List<Lead> lds = [select id from Lead where email=:wrapper.email limit 1];
        if(lds.isEmpty()){
            List<Contact> cts = [select id from Contact where email=:wrapper.email limit 1];
            if(cts.isEmpty()){
                WrapLead wLead = new WrapLead(wrapper.firstName, wrapper.lastName, 'Client', wrapper.phone, wrapper.email, 'Open - Not Contacted', 'BYN');
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
    public class Wrapper{
        @AuraEnabled public String firstName {get; set;}
        @AuraEnabled public String lastName {get; set;}
        @AuraEnabled public String phone {get; set;}
        @AuraEnabled public String email {get; set;}
        @AuraEnabled public String idCenter {get; set;}
    }
}
