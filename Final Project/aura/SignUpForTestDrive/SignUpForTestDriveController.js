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
        let action = component.get("c.getAutoCenters");
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const items = response.getReturnValue();
				
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
    signUp: function (component, evt, helper) {
        let allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            const fname = component.get("v.firstname");
            const lname = component.get("v.lastname");
            const phone = component.get("v.phone");
            const email = component.get("v.email");
            const idCenter = component.get("v.sl");
            let action = component.get("c.createCase");
            action.setParams({
                firstName : fname, 
                lastName : lname, 
                phone : phone, 
                email : email,
                idCenter : idCenter,
            });
            action.setCallback(this, function(response) {
                const state = response.getState();
                component.set("v.isOpen", false);
                if (state === "SUCCESS") {
                    helper.showToast('success', $A.get('$Label.c.requestSaved'), $A.get('$Label.c.managerContact'), 5000);
                }else{
                    helper.showToast('error', $A.get('$Label.c.errorOccurred'), $A.get('$Label.c.tryLater'), 5000);
                } 
            });
            $A.enqueueAction(action);
        } else {
        }
    }
})
