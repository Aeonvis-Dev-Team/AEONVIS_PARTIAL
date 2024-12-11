public class opportunityTriggerSupport {

	//---------------------------Opportunity------------------------------
	//gestione ripetizione trigger
	public static Boolean disableOpportunityTrigger = false;

	//gestione delle azioni del trigger
	public static void OpportunityTriggerHandler(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap, List<Opportunity> listNew,
	                                             Boolean boolIsBefore, Boolean boolIsInsert, Boolean boolIsUpdate, Boolean boolIsDelete) {

		/*if(oldMap == NULL){
		  oldMap = new Map<Id, Opportunity>();
		  }
		  if(newMap == NULL){
		  newMap = new Map<Id, Opportunity>();
		  }
		  if(listNew == NULL){
		  listNew = new List<Opportunity>();
		  }*/

		if (boolIsBefore) {
			//if(boolIsInsert) {}
			//if(boolIsUpdate) {}
			//	if(boolIsDelete) {}
		} else { //i.e. trigger.isAfter
			if (boolIsInsert) {
				System.debug('AFTER INSERT');
				OppoCustomIntegration.opportunityHandler(null, newMap);
			}
			if (boolIsUpdate) {
				System.debug('AFTER UPDATE');
				OppoCustomIntegration.opportunityHandler(oldMap, newMap);
			}
			//	if(boolIsDelete) {}
		}
	}
	//---------------------------------------------------------------

}