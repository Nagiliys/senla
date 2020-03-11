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
        const family = component.get("v.carName");
        const actionEquipment = component.get("c.getEquipmentByFamily");
        actionEquipment.setParams({
            family:family
        });
        actionEquipment.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const cars = response.getReturnValue();
				
                let equipment = [];
                let car = {};
                for(let i=0; i<cars.length; i++){
                    car={
                        label: cars[i].Info__c,
                        value: cars[i].Id,
                    };
                    equipment.push(car);
                }
                component.set("v.equipmentList", equipment);  
            } 
        });
        $A.enqueueAction(actionEquipment);

        //center
        let actionCenters = component.get("c.getAutoCenters");
        actionCenters.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const centers = response.getReturnValue();
                let autoCenters = [];
                let center = {};
                for(let i=0; i<centers.length; i++){
                    center={
                        label: centers[i].Name+' '+centers[i].City__c,
                        value: centers[i].Id,
                    };
                    autoCenters.push(center);
                }
                component.set("v.servicelist", autoCenters);
            } 
        });
        $A.enqueueAction(actionCenters);
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
            const fname = component.get("v.firstname");
            const lname = component.get("v.lastname");
            const phone = component.get("v.phone");
            const email = component.get("v.email");
            const idCenter = component.get("v.serviceValue");
            const idCar = component.get("v.equipmentValue")
            let action = component.get("c.createOrder");
            action.setParams({
                firstName : fname, 
                lastName : lname, 
                phone : phone, 
                email : email,
                idCenter : idCenter,
                idCar : idCar,
            });
            action.setCallback(this, function(response) {
                const state = response.getState();
                component.set("v.isOrderOpen", false);
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
