public without sharing class EmployeeManager {
    public static Id getFreeEmployeeByIdCenter(Id idCenter){
        List<employee__c> emp = [select id, (select id from cases__r where Status!='Closed') from employee__c where AutoCenter__r.id=:idCenter];
        employee__c target = emp[0];
        integer min = emp[0].cases__r.size()+1;
        for(employee__c e : emp){
            if(min > e.cases__r.size()){
                min = e.cases__r.size();
                target = e;
            }
        }
        return target.id;
    }
}
