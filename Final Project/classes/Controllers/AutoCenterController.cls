public class AutoCenterController {
    @AuraEnabled(cacheable=true)
    public static List<AutoCenter__c> getAutoCenters(){
        return AutoCenterManager.getAutoCenters();
    }
    @AuraEnabled(cacheable=true)
    public static AutoCenter__c getAutoCenterById(Id id){
        return AutoCenterManager.getAutoCenterById(id);
    }
    @AuraEnabled(cacheable=true)
    public static List<AutoCenter__c> getAutoCentersByRecordType(String RT){
        return AutoCenterManager.getAutoCentersByRecordType(RT);
    }
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getMapAutoCenters(String searchString, String RT){
        return AutoCenterManager.getMapAutoCentersBySubName(searchString, RT);
    }
}
