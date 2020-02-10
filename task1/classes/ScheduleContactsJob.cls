global class ScheduleTestJob implements Schedulable {
    
    global void execute (SchedulableContext sc){
        List<Contact> contacts = [select Days_before_new_year__c from Contact];
        for(Contact ct : contacts){
            Date today = Date.today();
            Date nextNewYear = Date.newInstance(today.year(), 12, 31);
            ct.Days_before_new_year__c = today.daysBetween(nextNewYear);    
        }
        update contacts;
    }
}
//ScheduleTestJob p = new ScheduleTestJob();
//String sch = '0 0 0 * * ?';
//system.schedule('Update days before new year', sch, p);