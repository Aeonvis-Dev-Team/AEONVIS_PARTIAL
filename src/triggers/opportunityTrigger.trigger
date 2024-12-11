trigger opportunityTrigger on Opportunity(after insert, after update) {

    boolean active = (impTrigger__c.getValues(userinfo.getOrganizationId()) == null) ? false : impTrigger__c.getValues(userinfo.getOrganizationId()).opportunityTrigger__c;

    System.debug('active --- ' + active);

    if (active) {
        if (!opportunityTriggerSupport.disableOpportunityTrigger) {
            opportunityTriggerSupport.OpportunityTriggerHandler
            (trigger.oldMap,
             trigger.newMap,
             trigger.new,
             trigger.isBefore,
             trigger.isInsert,
             trigger.isUpdate,
             trigger.isDelete);
        }
    }


}