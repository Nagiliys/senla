public class ContactTriggerHandler extends TriggerHandler{
    protected override void beforeInsert(){
        Date today = Date.today();
        Date nextNewYear = Date.newInstance(today.year(), 12, 31);
        for(Contact ct : (List<Contact>)trigger.new){
            ct.Days_before_new_year__c = today.daysBetween(nextNewYear);   
        }
    }
}
