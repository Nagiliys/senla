({
    mapCenters : function(items) {
        let autoCenters = [];
        let item = {};
        for(let i=0; i<items.length; i++){
            item={
                location: {
                    Latitude: items[i].latitude__c,
                    Longitude: items[i].longitude__c,
                },
                icon: 'custom:custom'+(i+1),
                title: items[i].Name,
                description: items[i].Location__c
            };
            autoCenters.push(item);
        }       
        return autoCenters;
    },
    getCenters : function(component){
        let action = component.get("c.getAutoCenters");
        let centers;
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                centers = this.mapCenters(response.getReturnValue());
                component.set('v.mapMarkers', centers);   
            } 
        });
        $A.enqueueAction(action);
        component.set('v.mapMarkers', centers);
        component.set('v.zoomLevel', 6);
        component.set('v.markersTitle', 'Centers');
    },
    getCentersByRecordType : function(component){
        let action = component.get("c.getAutoCentersByRecordType");
        action.setParams({
			RT : component.get("v.filterValue")
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                let centers = this.mapCenters(response.getReturnValue());
                component.set('v.mapMarkers', centers);
            }
        });
        $A.enqueueAction(action);
    },
    findCenterBySubName :function(component, subName){
        let action = component.get("c.getMapAutoCenters");
        const recordType = component.get("v.filterValue");
        action.setParams({
            searchString: subName,
            RT:recordType
        });
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const objectMap = response.getReturnValue();
                let objects = [];
                if (response != null ) {
                    for(let key in objectMap){
                        objects.push(
                            {
                                id: key,
                                name: objectMap[key]                                
                            });
                    }
                }
                if(!component.get("v.searchKey")){
                    component.set('v.centerList',null);
                }else{
                    component.set("v.centerList", objects);
                }
            }
        });
        $A.enqueueAction(action);
    }
})