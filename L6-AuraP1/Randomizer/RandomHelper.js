({
	showToast: function() {
		let toastEvent = $A.get("e.force:showToast");
		const title = $A.get("$Label.c.title_valid_err");
		const message = $A.get("$Label.c.msg_valid_err");
		toastEvent.setParams({
			title : title,
			message: message,
			duration:' 5000',
			key: 'info_alt',
			type: 'error',
			mode: 'pester'
		    });
		toastEvent.fire();
	}    
})
