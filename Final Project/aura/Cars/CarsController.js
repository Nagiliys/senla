({
    init: function(component, event, helper) {
		$A.get("$Label.c.geely_atlas_description");
		$A.get("$Label.c.geely_coolray_description");
		$A.get("$Label.c.geely_emgrand_7_description");
        $A.get("$Label.c.geely_emgrand_x7_description");   
	},
    openModal: function(component, event, helper) {
        component.set("v.isOpen", true);
        const car =  event.target.id;
        component.set("v.car",car);
        component.set("v.carName",car);
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

        //equipment
        const family = component.get("v.carName");
        var actionEquipment = component.get("c.getEquipmentByFamily");
        actionEquipment.setParams({
            family:family
        });
        actionEquipment.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var cars = response.getReturnValue();
				
                let equipment = [];
                let car = {};
                for(let i=0; i<cars.length; i++){
                    car={
                        label: cars[i].Info__c,
                        value: cars[i].Id,
                    };
                    equipment.push(car);
                }
                component.set("v.EquipmentValue", equipment);  
            } 
        });
        $A.enqueueAction(actionEquipment);

        //center
        var actionCenters = component.get("c.getAutoCenters");
        actionCenters.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var centers = response.getReturnValue();
                let autoCenters = [];
                let center = {};
                for(let i=0; i<centers.length; i++){
                    center={
                        label: centers[i].Name+' '+centers[i].City__c,
                        value: centers[i].Id,
                    };
                    autoCenters.push(center);
                }
                component.set("v.ServiceValue", autoCenters);
            } 
        });
        $A.enqueueAction(actionCenters);
    },
    closeOrderModal: function(component, event, helper) {  
        component.set("v.isOrderOpen", false);
    },
    Order: function(cmp, event, helper) {
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
            const idCar = cmp.get("v.el")
            var action = cmp.get("c.createOrder");
            action.setParams({
                firstName : fname, 
                lastName : lname, 
                phone : phone, 
                email : email,
                idCenter : idCenter,
                idCar : idCar,
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                cmp.set("v.isOrderOpen", false);
                if (state === "SUCCESS") {
                    helper.showToast('success', $A.get('$Label.c.orderSaved'), $A.get('$Label.c.managerContact'), 5000);
                }else{
                    helper.showToast('error', $A.get('$Label.c.errorOccurred'), $A.get('$Label.c.tryLater'), 5000);
                } 
            });
            $A.enqueueAction(action);
        } 
    },
    updateCurr: function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var curr = params.curr;
            component.set("v.curr", curr);
        }
    },
    openPDF: function(component, event, helper) {
      const car = component.get("v.car");
      const curr = component.get("v.curr");
      window.open('https://gelly-developer-edition.ap15.force.com/GeelyPrice?curr='+curr+'&car='+car.replace(' ','%20'), '_blank');
   }
})
