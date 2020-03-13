public without sharing class AutoCenterManager {
    public static List<AutoCenter__c> getAutoCenters(){
        return [select Name, City__c, latitude__c, longitude__c, Description__c, Location__c from AutoCenter__c];
    }

    public static List<AutoCenter__c> getDillerAutoCenters(){
        return [select Name, City__c from AutoCenter__c where RecordType.Name!='Service'];
    }


    public static AutoCenter__c getAutoCenterById(Id id){
        return [select Name, latitude__c, longitude__c,  (select Name from staff__r) from AutoCenter__c where id=:id];
    }

    public static List<AutoCenter__c> getAutoCentersByRecordType(String RT){
        if(RT=='All'){
            return getAutoCenters();
        }
        return [select Name, latitude__c, longitude__c, Description__c from AutoCenter__c where RecordType.Name=:RT or RecordType.Name='All'];
    }

    public static Map<String, String> getMapAutoCentersBySubName(String subName, String RT){
        map<string, string> mapCenters = new map<string, string>();
        list<AutoCenter__c> centers;
        if(RT=='All'){
            centers = [select id, name, City__c from AutoCenter__c where name like :'%'+subName+'%'];
        }else {
            centers = [select id, name, City__c from AutoCenter__c where name like :'%'+subName+'%' and (RecordType.Name=:RT or RecordType.Name='All')];
        }
        
        for(AutoCenter__c center : centers){
            mapCenters.put(center.id, center.name+' '+center.City__c);
        }
        return mapCenters;
    }
    
}
