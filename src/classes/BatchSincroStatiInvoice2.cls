global class BatchSincroStatiInvoice2 implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {

	public static List<TIC_Custom_Log__c> TICLog = new List<TIC_Custom_Log__c> ();

	/**
	 * @description gets invoked when the batch job starts
	 * @param context contains the job ID
	 * @returns the record set as a QueryLocator object that will be batched for execution
	 */
	global Database.QueryLocator start(Database.BatchableContext context) {
		IntegrationTIC__c IntegrationTIC = IntegrationTIC__c.getOrgDefaults();

		System.debug('STATI FINALI ---> ' + IntegrationTIC.Stati_Finali__c);

		return Database.getQueryLocator('SELECT Id,Name,Invoice_status__c,Account__r.Company_name__c,Bill_with__c,TIC_draft_no__c,Data_Ordine__c,Billing_date__c,TIC_invoice_no__c,Opportunity__r.Name,Bill_to__r.Company_name__c FROM Billing_Item__c WHERE TIC_draft_no__c != null and Invoice_status__c NOT IN (' + IntegrationTIC.Stati_Finali__c + ')');
	}

	/**
	 * @description gets invoked when the batch job executes and operates on one batch of records. Contains or calls the main execution logic for the batch job.
	 * @param context contains the job ID
	 * @param scope contains the batch of records to process.
	 */
	global void execute(Database.BatchableContext context, List<Billing_Item__c> scope) {
		try {

			List<Billing_Item__c> listBillingItems = new List<Billing_Item__c> ();
			listBillingItems = scope;

			//ciclo ogni billing item
			for (Billing_Item__c BI : listBillingItems)
			{
				//prendo solo i billing item "padri"
				if (String.isNotBlank(BI.Bill_with__c) == false)
				{
					//chiamata al servizio per retrieve stato
					Boolean EsitoGetStatus = TICApi.retrieveStatusInvoice(listBillingItems);
				}
			}
		} catch(Exception e) {
			System.debug('CAPTION --- ' + e.getMessage());
			string NameLog = 'Batch Sincro Stati Invoice ' + String.valueOf(Datetime.now().format('dd/MM/yyyy'));string description = 'Qualcosa è andato storto (catch) la classe schedulata BatchSincroStatiInvoice. Messaggio errore ' + e.getMessage() + '\n' + 'Line: ' + e.getLineNumber();TIC_Custom_Log__c log = CustomLog.log(NameLog, description, 'Errore batch', 'BatchSincroStatiInvoice - execute');BatchSincroStatiInvoice.TICLog.add(log);
		}
	}

	/**
	 * @description gets invoked when the batch job finishes. Place any clean up code in this method.
	 * @param context contains the job ID
	 */
	global void finish(Database.BatchableContext context) {

		System.debug('Record log da scrivere --> ' + TICLog);
		insert TICLog;

	}
}