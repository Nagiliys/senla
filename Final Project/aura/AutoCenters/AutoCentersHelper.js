({
    mapCenters : function(items) {
        let autoCenters = [];
        let item = {};
        for(let i=0; i<items.length; i++){
            item={
                location: {
                    Latitude: items[i].latitude__c,
                    Longitude: items[i].longitude__c,
                },
                icon: 'custom:custom'+(i+1),
                title: items[i].Name,
                description: items[i].Location__c
            };
            autoCenters.push(item);
        }       
        return autoCenters;
    }
})