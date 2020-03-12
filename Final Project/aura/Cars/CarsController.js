({
    init: function(component, event, helper) {
		$A.get("$Label.c.geely_atlas_description");
		$A.get("$Label.c.geely_coolray_description");
		$A.get("$Label.c.geely_emgrand_7_description");
        $A.get("$Label.c.geely_emgrand_x7_description");
        helper.getWrapper(component);
        helper.getCenters(component);
	},
    openModal: function(component, event, helper) {
        component.set("v.isOpen", true);
        const car =  event.target.id;
        component.set("v.car",car);
        const nameLabel = "$Label.c."+car.split(' ').join('_')+'_description';
        const label = $A.get(nameLabel);
        component.set("v.carDescription", label);
	},
    closeModal: function(component, event, helper) {  
        component.set("v.isOpen", false);
    },
    openOrderModal: function(component, event, helper) {  
        component.set("v.isOpen", false);
        component.set("v.isOrderOpen", true);
        helper.getEquipments(component);
    },
    closeOrderModal: function(component, event, helper) {  
        component.set("v.isOrderOpen", false);
    },
    Order: function(component, event, helper) {
        let allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            helper.createOrder(component);
        } 
    },
    updateCurr: function(component, event, helper) {
        const params = event.getParam('arguments');
        if (params) {
            const curr = params.curr;
            component.set("v.curr", curr);
        }
    },
    openPDF: function(component, event, helper) {
      const car = component.get("v.car");
      const curr = component.get("v.curr");
      window.open('https://gelly-developer-edition.ap15.force.com/GeelyPrice?curr='+curr+'&car='+car.replace(' ','%20'), '_blank');
   }
})
