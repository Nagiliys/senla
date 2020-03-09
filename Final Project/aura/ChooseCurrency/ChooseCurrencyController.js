({	
	reloadCurrency : function (component, event, helper) {
		var curr = component.get("v.cs");
		var updateCurr = component.getEvent("changeCurr");
		updateCurr.setParams({"curr":curr});
		updateCurr.fire();
	}
})
