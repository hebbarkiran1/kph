({
    doInit : function(component, event, helper) {
        var currRecordId = component.get("v.recordId");
        component.set("v.recdid", currRecordId );
        //console.log('record id :: ' + currRecordId);
    }
})