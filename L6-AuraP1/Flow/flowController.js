({
    init : function (component, event, helper) {
    const recordId = component.get("v.recordId");    
    const pagetype = component.get("v.sObjectName");   
    if (pagetype == "Account" && recordId!="") {
        const flow = component.find("flowData");
        const input = [{ name : "recordId", type : "String", value: recordId}];
        flow.startFlow("update", input);
    } else {
        component.set("v.bagdeValue", $A.get("$Label.c.cmpNameErr"));
    }      
  }
})