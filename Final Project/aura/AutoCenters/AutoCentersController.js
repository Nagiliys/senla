({
    init: function (component, event, helper) {
        let action = component.get("c.getAutoCenters");
        let centers;
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                centers = helper.mapCenters(response.getReturnValue());
                component.set('v.mapMarkers', centers);   
            } 
        });
        $A.enqueueAction(action);
        component.set('v.mapMarkers', centers);
        component.set('v.zoomLevel', 6);
        component.set('v.markersTitle', 'Centers');
    },
    reloadMapForFilter : function (component, event, helper) {     
        let action = component.get("c.getAutoCentersByRecordType");
        action.setParams({
			RT : component.get("v.filterValue")
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                let centers = helper.mapCenters(response.getReturnValue());
                component.set('v.mapMarkers', centers);
                
            }
        });
        $A.enqueueAction(action);
    }, 
    getCenterList: function(component, event, helper) {
        const serString = component.get("v.searchKey");
        if(!serString){
            component.set('v.centerList',null);
            return;
        }

        let action = component.get("c.getMapAutoCenters");
        const recordType = component.get("v.filterValue");
        action.setParams({
            searchString: serString,
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
                    return;
                }else{
                    component.set("v.centerList", objects);
                }
            }
        });
        $A.enqueueAction(action);
    },
    selectOption:function(component, event, helper) {
        const centerId=event.currentTarget.dataset.value;
        window.open('https://gelly-developer-edition.ap15.force.com/AutoCenterInfo?Id='+centerId, '_blank');
    }
});
