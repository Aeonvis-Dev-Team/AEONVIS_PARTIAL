public class OppoCustomIntegration {
	public static void opportunityHandler(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {

		if (newMap.size() == 1 && oldMap == null &&
		   (newMap.values().get(0).StageName == 'Closed Won' || newMap.values().get(0).StageName == 'Closed Negotiation') &&
		   (newMap.values().get(0).Line_of_Business__c.toUpperCase() == 'CRM')) { //in creazione opp crea documento note nella cartella Sales

			//invia id opportunita alla org AP, la org AP esegue poi una select per riprendere tutti i campi necessari
			SendOpportunityToAP.sendOppoID(newMap.values().get(0).id);

		} else if (newMap.size() == 1 && oldMap != null &&
		           newMap.values().get(0).StageName != oldMap.values().get(0).StageName &&
				   (newMap.values().get(0).StageName == 'Closed Won' || newMap.values().get(0).StageName == 'Closed Negotiation') &&
				   (oldMap.values().get(0).StageName != 'Closed Negotiation') &&
				   (newMap.values().get(0).Line_of_Business__c.toUpperCase() == 'CRM')) {

			System.debug('NEW StageName --- ' + newMap.values().get(0).StageName);
			System.debug('OLD StageName --- ' + oldMap.values().get(0).StageName);
			System.debug('UPDATE --- ' + newMap);
			//invia id opportunita alla org AP, la org AP esegue poi una select per riprendere tutti i campi necessari
			SendOpportunityToAP.sendOppoID(newMap.values().get(0).id);
		}
	}
}