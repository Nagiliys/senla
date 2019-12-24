({
    init : function (component, event, helper) {
    var recordId = component.get("{!v.recordId}")    
    var pagetype = component.get("{!v.sobjecttype}")
    if (pagetype == "Account" && recordId!="") {
        var flow = component.find("flowData");
        var input = [{ name : "recordId", type : "String", value: recordId}]
        flow.startFlow("update", input);
    } else {
        var label = $A.get("$Label.c.error")
        alert(label)
    }      
  }
})