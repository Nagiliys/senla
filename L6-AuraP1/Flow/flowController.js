({
    init : function (component, event, helper) {
        const recordId = component.get("v.recordId");    
        const pagetype = component.get("v.sObjectName");   
        const flow = component.find("flowData");
        const input = [{ name : "recordId", type : "String", value: recordId}];
        flow.startFlow("update", input);
        component.set("v.cmpNameErr", $A.get("$Label.c.cmpNameErr"))   
  }
})