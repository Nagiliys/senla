({
    init : function (component, event, helper) {
		const recordId = component.get('v.contactId');

		var action = component.get("c.isPossibleToCreateFeedback");
		action.setParams({
            ct : recordId, 
        });
        action.setCallback(this, function(response) {
			var state = response.getState();
            if (state === "SUCCESS") {
				var isPossible = response.getReturnValue();
				if(isPossible){
					const flow = component.find("flowData");
					const param = [{ name : "contactId", type : "String", value: recordId}];
					flow.startFlow("leave_feedback", param);
				}else{
					component.set('v.active',false);
					component.set('v.message', 'you have sent the maximum number of feedback');
				}
            } 
		});
		$A.enqueueAction(action);
			  
    },
    finish: function(component, event, helper) {
		if (event.getParam('status') === "FINISHED") {
			component.set('v.active',false);
			component.set('v.message', 'you send feedback');
		}
	},
})
