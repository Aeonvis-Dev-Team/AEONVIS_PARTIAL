@isTest
public class Test_TICApi {
	@TestVisible
	public static String testing;

	@TestSetup
	private static void dataFactory() {
		IntegrationTIC__c im = DataFactory.createCustomSettingsTIC();
		//List<account> Acc = DataFactory.createAccount(1, 'Luca');
		account AccPartners = DataFactory.createAccountPartners('Luca Partners');
		account AccContractor = DataFactory.createAccountContractor('Contractor');
		Opportunity Oppo = DataFactory.createOpportunity(AccPartners, AccContractor);
		Billing_Item__c BillItm = dataFactory.cretateBillingItems(Oppo, AccPartners);
	}
	
	@isTest
	private static void SendInvoice200()
	{
		List<Billing_Item__c> BillItm = [SELECT Id, Bill_with__c, TIC_draft_no__c FROM Billing_Item__c WHERE Name = 'test riga 1' LIMIT 1];

		List<Id> ListIdBillItm = new List<Id> ();
		ListIdBillItm.add(BillItm[0].Id);

		Test.startTest();
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		testing = 'SendToTIC';
		TICApi.sendInvoiceTIC(ListIdBillItm);
		Test.stopTest();
	}

	@isTest
	private static void SendInvoice400()
	{
		List<Billing_Item__c> BillItm = [SELECT Id, Bill_with__c, TIC_draft_no__c FROM Billing_Item__c WHERE Name = 'test riga 1' LIMIT 1];

		List<Id> ListIdBillItm = new List<Id> ();
		ListIdBillItm.add(BillItm[0].Id);

		Test.startTest();
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		testing = 'SendToTIC400';
		TICApi.sendInvoiceTIC(ListIdBillItm);
		Test.stopTest();
	}

	@isTest
	private static void RetrieveStatus200()
	{
		List<Billing_Item__c> BillItm = [SELECT Id, Name,Data_Ordine__c, Invoice_status__c, Account__r.Company_name__c, Bill_with__c, TIC_draft_no__c, Billing_date__c, TIC_invoice_no__c, Opportunity__r.Name, Bill_to__r.Company_name__c FROM Billing_Item__c WHERE Name = 'test riga 1' LIMIT 1];
		System.debug('TIC_draft_no__c ---> ' + BillItm[0].TIC_draft_no__c);
		Test.startTest();
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		testing = 'RetrieveStatusTIC';
		TICApi.retrieveStatusInvoice(BillItm);
		Test.stopTest();
	}

	@isTest
	private static void RetrieveStatus400()
	{
		List<Billing_Item__c> BillItm = [SELECT Id, Name,Data_Ordine__c, Invoice_status__c, Account__r.Company_name__c, Bill_with__c, TIC_draft_no__c, Billing_date__c, TIC_invoice_no__c, Opportunity__r.Name, Bill_to__r.Company_name__c FROM Billing_Item__c WHERE Name = 'test riga 1' LIMIT 1];
		System.debug('TIC_draft_no__c ---> ' + BillItm[0].TIC_draft_no__c);
		Test.startTest();
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		testing = 'RetrieveStatusTIC400';
		TICApi.retrieveStatusInvoice(BillItm);
		Test.stopTest();
	}

	@isTest
	private static void RetrieveStatusCatch()
	{
		List<Billing_Item__c> BillItm = [SELECT Id, Name,Data_Ordine__c, Invoice_status__c, Account__r.Company_name__c, Bill_with__c, TIC_draft_no__c, Billing_date__c, TIC_invoice_no__c, Opportunity__r.Name, Bill_to__r.Company_name__c FROM Billing_Item__c WHERE Name = 'test riga 1' LIMIT 1];
		System.debug('TIC_draft_no__c ---> ' + BillItm[0].TIC_draft_no__c);
		Test.startTest();
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		testing = 'RetrieveStatusTIC';
		TICApi.retrieveStatusInvoice(null);
		Test.stopTest();
	}

	@isTest
	private static void RetrieveStatusNumFatt()
	{
		List<Billing_Item__c> BillItm = [SELECT Id, Name, Data_Ordine__c,Invoice_status__c, Account__r.Company_name__c, Bill_with__c, TIC_draft_no__c, Billing_date__c, TIC_invoice_no__c, Opportunity__r.Name, Bill_to__r.Company_name__c FROM Billing_Item__c WHERE Name = 'test riga 1' LIMIT 1];
		BillItm[0].TIC_invoice_no__c = '10/IT';
		BillItm[0].TIC_draft_no__c = '10/IT';
		update BillItm[0];
		System.debug('TIC_draft_no__c ---> ' + BillItm[0].TIC_draft_no__c);
		System.debug('TIC_invoice_no__c ---> ' + BillItm[0].TIC_invoice_no__c);
		Test.startTest();
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		testing = 'RetrieveStatusTIC';
		TICApi.retrieveStatusInvoice(BillItm);
		Test.stopTest();
	}

	@isTest
	private static void generaXMLRetrieveStatusCatch()
	{
		List<Billing_Item__c> BillItm = [SELECT Id, Name,Data_Ordine__c, Invoice_status__c, Account__r.Company_name__c, Bill_with__c, TIC_draft_no__c, Billing_date__c, TIC_invoice_no__c, Opportunity__r.Name, Bill_to__r.Company_name__c FROM Billing_Item__c WHERE Name = 'test riga 1' LIMIT 1];

		System.debug('TIC_draft_no__c ---> ' + BillItm[0].TIC_draft_no__c);
		System.debug('TIC_invoice_no__c ---> ' + BillItm[0].TIC_invoice_no__c);
		Test.startTest();
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		testing = 'RetrieveStatusTIC';
		TICApiHelper.generaXMLRetrieveStatus(BillItm);
		Test.stopTest();
	}

	@isTest
	private static void testSchedule() {
		Test.startTest();

		// Schedule the test job
		String CRON_EXP = '0 0 0 3 9 ? 2042';
		String jobId = System.schedule('BatchSincroStatiInvoice', CRON_EXP, new SchedulableBatchSincroStatiInvoice());

		Test.stopTest();
	}

	@isTest
	private static void testSchedule2() {
		Test.startTest();

		// Schedule the test job
		String CRON_EXP = '0 0 0 3 9 ? 2042';
		String jobId = System.schedule('BatchSincroStatiInvoice2', CRON_EXP, new SchedulableBatchSincroStatiInvoice());

		Test.stopTest();
	}
	
	@isTest
	private static void structure()
	{
		List<TICstructure.dettaglioStatus> ListdettaglioStatus = new List<TICstructure.dettaglioStatus> ();
		TICstructure.dettaglioStatus dettaglioStatus = new TICstructure.dettaglioStatus();
		dettaglioStatus.data = '2024-05-01';
		dettaglioStatus.stato = '2024-05-01';
		dettaglioStatus.tipdoc = '2024-05-01';
		ListdettaglioStatus.add(dettaglioStatus);

		TICstructure.responseStatus responseStatus = new TICstructure.responseStatus();
		responseStatus.ragsoc = '2024-05-01';
		responseStatus.numtic = '2024-05-01';
		responseStatus.tipdoc = '2024-05-01';
		responseStatus.data = '2024-05-01';
		responseStatus.totale = 1;
		responseStatus.dettaglio = ListdettaglioStatus;

		TICstructure.Evasioni Evasioni = new TICstructure.Evasioni();

		Evasioni.numtic = '2024-05-01';
		Evasioni.stato = '2024-05-01';
		Evasioni.tipdoc = '2024-05-01';
		Evasioni.data = '2024-05-01';
		Evasioni.dataori = '2024-05-01';
		Evasioni.numticori = '2024-05-01';
		Evasioni.tipdocori = '2024-05-01';

		TICstructure.responseSendTIC responseSendTIC = new TICstructure.responseSendTIC();
		responseSendTIC.ragsoc = '2024-05-01';
		responseSendTIC.numtic = '2024-05-01';
		responseSendTIC.data = '2024-05-01';
		responseSendTIC.totale = 200;
		responseSendTIC.dettaglio = '2024-05-01';
		responseSendTIC.num = '2024-05-01';


		TICstructure.Documento Documento = new TICstructure.Documento();
		Documento.numero = 'a';
		Documento.cognome = 'a';
		Documento.nome = 'a';
		Documento.codicefiscale = 'a';
		Documento.numerocivico = 'a';
		Documento.email = 'a';
		Documento.stato = 'a';
		Documento.prezzoLordo = 200;
	}
	
	//commit 


}