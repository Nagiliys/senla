({
	random : function(component, event, helper) {      
        var value1 = parseInt(component.get("{!v.value1}"));
        var value2 = parseInt(component.get("{!v.value2}"));
        var value = parseInt(Math.random() * (value1 - value2) + value2)
        component.set("v.result", (value))
	}
})