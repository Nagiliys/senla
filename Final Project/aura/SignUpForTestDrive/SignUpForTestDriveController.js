({
    init : function(component, event, helper) {      
        helper.getCenters(component);
        helper.getWrapper(component);
	},
    OpenModal : function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    closeModal : function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    signUp: function (component, evt, helper) {
        let allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            helper.createCase(component);
        }
    }
})
