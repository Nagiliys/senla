public without sharing class EmployeeManager {
    public static String getFreeEmployee(){
        List<employee__c> emp = [select id, (select id from cases__r where Status!='Closed') from employee__c];
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
    public static String getFreeEmployeeByIdCenter(Id idCenter){
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
/*
        do not work without open cases

        AggregateResult res = [select employee__c from case where status!='Closed' group by employee__c order by count(Id) asc limit 1];
        return (String)res.get('employee__c');

        AggregateResult res = [select employee__c from case where employee__r.Autocenter__c=:idCenter and status!='Closed' group by employee__c order by count(Id) asc limit 1];
        return (String)res.get('employee__c');
*/