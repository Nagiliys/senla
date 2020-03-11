public class FeedbackTriggerHandler extends TriggerHandler{
    protected override void beforeInsert(){
        for(Feedback__c fb : (List<Feedback__c>)trigger.new){
            if(fb.contact__c==null && fb.ct__c!=null){
                fb.contact__c=fb.ct__c;
                fb.ct__c=null;
            }  
        }    
    }
}
