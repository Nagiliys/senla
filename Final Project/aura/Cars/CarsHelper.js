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
    }
})
