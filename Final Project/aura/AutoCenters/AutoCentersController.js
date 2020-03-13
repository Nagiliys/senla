({
    init: function (component, event, helper) {
        helper.getCenters(component);
    },
    reloadMapForFilter : function (component, event, helper) {     
        helper.getCentersByRecordType(component);
    }, 
    getCenterList: function(component, event, helper) {
        const subName = component.get("v.searchKey");
        if(!subName){
            component.set('v.centerList',null);
        }else{
            helper.findCenterBySubName(component, subName);
        }
    },
    selectCenter:function(component, event, helper) {
        const centerId = event.currentTarget.dataset.value;
        window.open('https://gelly-developer-edition.ap15.force.com/AutoCenterInfo?Id='+centerId, '_blank');
    }
});
