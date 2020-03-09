({
    init: function (cmp, event, helper) {
        var action = cmp.get("c.getAutoCenters");
        let centers;
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                centers = helper.mapCenters(response.getReturnValue());
                cmp.set('v.mapMarkers', centers);   
            } 
        });
        $A.enqueueAction(action);
        cmp.set('v.mapMarkers', centers);
        cmp.set('v.zoomLevel', 6);
        cmp.set('v.markersTitle', 'Centers');
    },
    reloadPageForFilter : function (cmp, event, helper) {     
        var action = cmp.get("c.getAutoCentersByRecordType");
        action.setParams({
			RT : cmp.get("v.fs")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let centers = helper.mapCenters(response.getReturnValue());
                cmp.set('v.mapMarkers', centers);
                
            }
        });
        $A.enqueueAction(action);
    }, 
    getObjectList: function(component, event, helper) {
        var serString = component.get("v.searchKey");
        if(!serString){
            component.set('v.ObjectList',null);
            return;
        }

        var action = component.get("c.getMapAutoCenters");
        var recordType = component.get("v.fs");
        action.setParams({
            searchString: serString,
            RT:recordType
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var objectMap = response.getReturnValue();
                var objects = [];
                if (response != null ) {
                    for(var key in objectMap){
                        objects.push(
                            {
                                id: key,
                                name: objectMap[key]                                
                            });
                    }
                }
                if(!component.get("v.searchKey")){
                    component.set('v.ObjectList',null);
                    return;
                }else{
                    component.set("v.ObjectList", objects);
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
