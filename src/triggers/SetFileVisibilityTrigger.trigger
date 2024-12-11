trigger SetFileVisibilityTrigger on ContentDocumentLink (before insert)  { 
	
	 if(ImpTrigger__c.getValues(userinfo.getOrganizationId()).SetFileVisibility__c){
       if(!SetFileVisibilityTriggerSupport.disableSetFileVisibilityTrigger){
            SetFileVisibilityTriggerSupport.SetFileVisibilityTriggerHandler
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