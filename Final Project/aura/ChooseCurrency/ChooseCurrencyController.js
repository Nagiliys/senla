({	
	reloadCurrency : function (component, event, helper) {
		const curr = component.get("v.cs");
		const updateCurr = component.getEvent("changeCurr");
		updateCurr.setParams({"curr":curr});
		updateCurr.fire();
	}
})
