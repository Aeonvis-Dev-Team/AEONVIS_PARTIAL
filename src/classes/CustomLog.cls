public class CustomLog {

	public static TIC_Custom_Log__c log(string NameLog, string description, string oggetto, string classe)
	{
		TIC_Custom_Log__c log = new TIC_Custom_Log__c();

		log.Name = NameLog;
		log.Description__c = description;
		log.Name = NameLog;
		log.Class_Name__c = classe;

		return log;
	}

}