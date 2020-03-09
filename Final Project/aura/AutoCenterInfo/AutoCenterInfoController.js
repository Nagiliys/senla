({
    init : function(component, event, helper) {
        let action = component.get("c.getAutoCentersById");
        const centerId = component.get('v.centerId');
        action.setParams({
            id: centerId
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const center = response.getReturnValue();
                const map =[
                    {
                        location: {
                            Latitude: center.latitude__c,
                            Longitude: center.longitude__c,
                        },
        
                        title: center.Name,
                        description: 'geely center'
                    }];
                component.set('v.mapMarkers', map);
                component.set('v.staff', center.staff__r);
            } 
        });
        $A.enqueueAction(action);
    }
})
