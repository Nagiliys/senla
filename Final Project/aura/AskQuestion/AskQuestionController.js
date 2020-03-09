({
    OpenModal : function(component, event, helper) {
        component.set("v.isOpen", true);
    },

    closeModal : function(component, event, helper) {
        component.set("v.isOpen", false);
        component.set("v.StaffValue",[]);
        component.set("v.sl", "");
        component.set("v.st", "");
    },
    init : function(component, event, helper) {      
        var action = component.get("c.getAutoCenters");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var items = response.getReturnValue();
				
                let autoCenters = [];
                let item = {};
                for(let i=0; i<items.length; i++){
                    item={
                        label: items[i].Name+' '+items[i].City__c,
                        value: items[i].Id,
                    };
                    autoCenters.push(item);
                }
                component.set("v.ServiceValue",autoCenters);  
            } 
        });
        $A.enqueueAction(action);
	},
    ask: function (cmp, evt, helper) {
        var allValid = cmp.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            const fname = cmp.get("v.firstname");
            const lname = cmp.get("v.lastname");
            const phone = cmp.get("v.phone");
            const email = cmp.get("v.email");
            const idCenter = cmp.get("v.sl");
            const subject = cmp.get("v.subject");
            const description = cmp.get("v.description");
            var action = cmp.get("c.createCase");
            action.setParams({
                firstName : fname, 
                lastName : lname, 
                phone : phone, 
                email : email,
                idCenter : idCenter,
                subject : subject,
                description : description,
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    helper.showToast('success', $A.get('$Label.c.questionSaved'), $A.get('$Label.c.managerContact'), 5000);
                }else{
                    helper.showToast('error', $A.get('$Label.c.errorOccurred'), $A.get('$Label.c.tryLater'), 5000);
                } 
            });
            $A.enqueueAction(action);
        } else {
        }
    }
})
