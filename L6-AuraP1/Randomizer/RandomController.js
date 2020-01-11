({
	random : function(component, event, helper) {      
        const valueFrom = parseInt(component.get("v.valueFrom")); //typeof valueTo and valueFrom equal string
        const valueTo = parseInt(component.get("v.valueTo"));	 // i don't know why
        if (valueFrom < valueTo){
            const result = parseInt(Math.random() * (valueTo - valueFrom) + valueFrom);
        component.set("v.result", result);
        } else {
            helper.showToast();  
        }
}
})