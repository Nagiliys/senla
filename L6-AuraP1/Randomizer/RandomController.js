({
	random : function(component, event, helper) {      
        const valueFrom = parseInt(component.get("v.valueFrom"));
        const valueTo = parseInt(component.get("v.valueTo"));
        if (valueFrom < valueTo){
            const result = parseInt(Math.random() * (valueTo - valueFrom) + valueFrom);
        	component.set("v.result", result);
        } else {
            helper.showToast();  
        }
    },
    checkFields: function(component, event, helper) {
  		const valueFrom = component.get("v.valueFrom");
        const valueTo = component.get("v.valueTo");
        if (valueFrom == null || valueTo == null || valueFrom == "" || valueTo == "") {
        	component.set("v.isActiveBtn", true);
        } else {
        	component.set("v.isActiveBtn", false);
    	}
  }
})