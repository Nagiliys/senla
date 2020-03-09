public virtual class TriggerHandler {
	public virtual void run(){
         if (trigger.IsInsert && trigger.IsBefore){
        	beforeInsert();
         } else if(trigger.IsInsert && trigger.IsAfter){
             afterInsert();
         }else if(trigger.IsUpdate && trigger.IsBefore){
             beforeUpdate();
         }else if(trigger.IsUpdate && trigger.IsAfter){
             afterUpdate();
         }else if(trigger.IsDelete && trigger.IsBefore){
             beforeDelete();
         }else if(trigger.IsDelete && trigger.IsAfter){
             afterDelete();
         }else if(trigger.IsUnDelete && trigger.IsAfter){
             afterUnDelete();
         }
    }
    
    protected virtual void beforeInsert(){}     
    protected virtual void afterInsert(){} 
    protected virtual void beforeUpdate(){} 
    protected virtual void afterUpdate(){} 
    protected virtual void beforeDelete(){} 
    protected virtual void afterDelete(){} 
    protected virtual void afterUnDelete(){} 
    
}