({
    showToast : function(type, title, msg, delay) {
        $A.get("e.c:ShowToastEvent")
                    .setParams({
                      type: type,
                      title: title,
                      description: msg,
                      delay: delay
                    })
                    .fire();
    },
    getWrapper : function(component){
      const action = component.get("c.getWrapper");
      action.setCallback(this, function(response) {
        const state = response.getState();
        if (state === "SUCCESS") {
          const wr = response.getReturnValue();
          component.set("v.wrap", wr);
        } 
      });
      $A.enqueueAction(action);
    },
    getCenters : function(component){
      let action = component.get("c.getAutoCenters");
      action.setCallback(this, function(response) {
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
          component.set("v.autoCenters", autoCenters);
        } 
      });
      $A.enqueueAction(action);
    },
    createCase : function(component){
      let action = component.get("c.createCase");
      const wrap = component.get("v.wrap");
      action.setParams({
          wrapper: wrap
      });
      action.setCallback(this, function(response) {
          const state = response.getState();
          component.set("v.isOpen", false);
          if (state === "SUCCESS") {
              this.showToast('success', $A.get('$Label.c.questionSaved'), $A.get('$Label.c.managerContact'), 5000);
          }else{
              this.showToast('error', $A.get('$Label.c.errorOccurred'), $A.get('$Label.c.tryLater'), 5000);
          }
      });
      $A.enqueueAction(action);
    }
})