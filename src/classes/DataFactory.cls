@isTest
public class DataFactory {

	public static ImpTrigger__c createCustomSettings() {
		ImpTrigger__c im = new ImpTrigger__c();
		im.SetupOwnerId = UserInfo.getOrganizationId();
		im.SetFileVisibility__c = true;
		insert im;
		return im;
	}

	public static IntegrationTIC__c createCustomSettingsTIC() {
		IntegrationTIC__c im = new IntegrationTIC__c();
		im.Stati_Finali__c = '\'CO\',\'RI\',\'NR\',\'MC\'';
		im.Password__c = 'DemoAeonvis24!';
		im.CodArtDescrittivo__c = 'CodProdDescrittivo';
		im.Serie_Est__c = 'ES';
		im.Serie_ITA__c = 'IT';
		im.Endpoint__c = 'https://tic0.zucchetti.com';
		im.UserName__c = 'emilio.ranzani@isi-it.eu_com';
		im.P_IVA_Emittente__c = '11111111111';
		im.AbilitaCheckIVA__c = true;
		im.SetupOwnerId = UserInfo.getOrganizationId();
		insert im;
		return im;
	}

	public static OpenAPI__c createCustomSettingsOpenAPI() {
		OpenAPI__c OpenApiCustom = new OpenAPI__c();
		OpenApiCustom.ApiKey__c = 'kghry2evqdmwcl36tvy0yv2mivob7wid';
		OpenApiCustom.EndPointCheckIVA__c = 'https://test.company.openapi.com/';
		OpenApiCustom.EndPointPR__c = 'https://test.cap.openapi.it/';
		OpenApiCustom.EndPointToken__c = 'https://test.oauth.openapi.it/token';
		OpenApiCustom.Utente__c = 'consulenze-dev@aeonvis.com';
		OpenApiCustom.Scopes_Company__c = 'test';
		OpenApiCustom.Scopes_PR__c = 'test';
		OpenApiCustom.SetupOwnerId = UserInfo.getOrganizationId();
		insert OpenApiCustom;
		return OpenApiCustom;
	}

	public static imptrigger__c createImTriggerOpportunity() {
		imptrigger__c im = new imptrigger__c(setupownerid = UserInfo.getOrganizationId(), opportunityTrigger__c = true);
		insert im;
		return im;
	}

	public static List<account> createAccount(integer xVolte, string nome)
	{
		List<Account> listaAccount = new List<Account> ();
		for (Integer i = 0; i<xVolte; i++)
		{
			account acc = new account(
			                          Name = nome + (i + 1), // Nome account
			                          Type = 'Prospect',
			                          Territory__c = 'Nord-Ovest',
			                          Codice_SDI__c = '1234567',
			                          Payment_terms__c = '030DF-IT',
			                          VAT_number__c = '12345698741',
			                          P_Iva_C_F__c = '12345698741',
			                          Company_name__c = nome + (i + 1),
			                          Size__c = 'Large',
			                          Phone = '0012365',
			                          BillingStreet = 'Via Francesco Antolisei',
			                          BillingCity = 'Roma',
			                          BillingPostalCode = '00173',
			                          BillingStateCode = 'RM',
			                          BillingLatitude = 1,
			                          BillingLongitude = 1,
			                          billingCountrycode = 'IT',
			                          ShippingStreet = 'Via Dedalo	',
			                          ShippingCity = 'Roma',
			                          ShippingPostalCode = '00133',
			                          ShippingStateCode = 'RM',
			                          ShippingCountrycode = 'IT',
			                          Shippinglatitude = 1,
			                          Shippinglongitude = 1

			);
			listaAccount.add(acc);

		}
		insert listaAccount;
		return listaAccount;

	}

	Public static account createAccountPartners(string nome)
	{
		account listaAccount = new account(
		                                   Name = nome, // Nome account
		                                   Type = 'Partner',
		                                   Territory__c = 'Centro-Sud',
		                                   Payment_terms__c = '030DF-IT',
		                                   Codice_SDI__c = '1234567',
		                                   Company_name__c = nome + ' Test',
		                                   VAT_number__c = '12345698741',
		                                   //P_Iva_C_F__c = '12345698741',
		                                   VAT_Code__c = 'N060201',
		                                   Size__c = 'Large',
		                                   Phone = '0012365',
		                                   BillingStreet = 'Via Francesco Antolisei',
		                                   BillingCity = 'Roma',
		                                   BillingPostalCode = '00173',
		                                   BillingStateCode = 'RM',
		                                   BillingLatitude = 1,
		                                   billingCountryCode = 'IT',
		                                   BillingLongitude = 1,
		                                   ShippingStreet = 'Via Dedalo	',
		                                   ShippingCity = 'Roma',
		                                   ShippingPostalCode = '00133',
		                                   ShippingStateCode = 'RM',
		                                   ShippingCountryCode = 'IT',
		                                   Shippinglatitude = 1,
		                                   Shippinglongitude = 1,
		                                   Declaration_intent_number__c = '111',
		                                   Declaration_of_intent__c = System.Date.today()
		);


		insert listaAccount;
		return listaAccount;

	}

	Public static account createAccountContractor(string nome)
	{
		account listaAccount = new account(
		                                   Name = nome, // Nome account
		                                   Type = 'Partner',
		                                   Territory__c = 'Nord-Est',
		                                   Payment_terms__c = '030DF-IT',
		                                   Codice_SDI__c = '7654321',
		                                   Size__c = 'Large',
		                                   Company_name__c = nome + ' Test',
		                                   VAT_number__c = '12345698741',
		                                   P_Iva_C_F__c = '12345698741',
		                                   VAT_Code__c = 'N060201',
		                                   Phone = '00123151',
		                                   BillingStreet = 'Via test',
		                                   BillingCity = 'Roma',
		                                   BillingPostalCode = '00100',
		                                   BillingStateCode = 'RM',
		                                   BillingLatitude = 1,
		                                   BillingLongitude = 1,
		                                   billingCountryCode = 'IT',
		                                   ShippingStreet = 'Via prova',
		                                   ShippingCity = 'Roma',
		                                   ShippingPostalCode = '00133',
		                                   ShippingStateCode = 'RM',
		                                   ShippingCountryCode = 'IT',
		                                   Shippinglatitude = 1,
		                                   Shippinglongitude = 1,
		                                   Declaration_intent_number__c = '111',
										   Data_Inizio_Dichiarazione_di_Intenti__c = System.Date.today()-10,
		                                   Declaration_of_intent__c = System.Date.today(),
										   Supplier_Code__c = 'Abcd'
		);


		insert listaAccount;
		return listaAccount;

	}


	public static Opportunity createOpportunity(Account accOppo, Account AccContractor)
	{
		Opportunity NewOppo = new Opportunity();


		NewOppo.Name = 'Test Oppo 5';
		NewOppo.StageName = 'Budget';
		NewOppo.AccountId = accOppo.Id;
		NewOppo.Open_date__c = Date.today();
		NewOppo.CloseDate = Date.today().addDays(1);
		NewOppo.Line_of_Business__c = 'CRM';
		NewOppo.Partner__c = accOppo.Id;
		NewOppo.Platform__c = 'Salesforce';
		NewOppo.Amount = 21000;
		NewOppo.Revenue__c = 10;
		NewOppo.Elapsed__c = 12;
		NewOppo.T_L__c = 'Not included - out of pocket';
		NewOppo.LeadSource = 'Salesforce event';
		NewOppo.Order_Date__c = Date.today();
		NewOppo.Order_Number__c = '123';
		NewOppo.Order_Amount__c = 25000;
		NewOppo.Contract_type__c = 'Consulting';
		//NewOppo.Engagement_Type__c = 'Forfait';
		NewOppo.Engagement_Type__c = 'T&M';
		NewOppo.Payment_terms__c = '030DF-IT';
		//NewOppo.Billin_Plan_Status__c = 'Not Completed';
		NewOppo.Bill_to__c = accOppo.Id;
		NewOppo.TR_Project_ID__c = 'AAA_123_22';
		NewOppo.Quality_review_status__c = 'Not Relevant';
		NewOppo.Residual_Capacity_Created__c = false;
		NewOppo.Numeratore_Appoggio__c = 1;
		NewOppo.Order_Date__c = System.Date.today();
		NewOppo.Code__c = 'AAAA';
		NewOppo.Offering__c = 'CRM';
		NewOppo.SUB_LOB__c = 'CRM';

		//NewOppo.Order_Number__c = System.Date.today();

		System.debug('NewOppo --> ' + NewOppo);

		insert NewOppo;

		return NewOppo;
	}

	public static Billing_Item__c cretateBillingItems(Opportunity Oppo, Account accOppo)
	{
		Billing_Item__c NewBillingItm = new Billing_Item__c();

		NewBillingItm.Billing_status__c = 'To be approved';
		NewBillingItm.Bill_to__c = accOppo.Id;
		NewBillingItm.Billing_expected_date__c = Date.valueOf('2024-06-23');
		NewBillingItm.Accrual_Year__c = '2024';
		NewBillingItm.Name = 'test riga 1';
		NewBillingItm.Billing_amount__c = 2500;
		NewBillingItm.Opportunity__c = Oppo.Id;
		NewBillingItm.TR_opportunity__c = 'AAA_123_22';
		NewBillingItm.Order_number__c = '987455';
		NewBillingItm.Payment_terms__c = '030DF-IT';
		NewBillingItm.Order_Amount__c = 100000;
		NewBillingItm.Data_scadenza__c = Date.today().addDays(20);
		NewBillingItm.TIC_draft_no__c = '11/IT';
		NewBillingItm.Entrata_merci__c = 'Test';
		NewBillingItm.Out_of_pocket_amount__c = 200;
		NewBillingItm.Billing_item_description_for_tic__c = 'Test';
		NewBillingItm.Data_Ordine__c =  Date.valueOf('2024-06-23');

		insert NewBillingItm;

		NewBillingItm.Tecnical_Status__c = true;
		NewBillingItm.Billing_status__c = 'Invoiced';
		NewBillingItm.Billing_date__c = Date.today().addDays(5);
		NewBillingItm.Billing_number__c = '123';

		update NewBillingItm;

		NewBillingItm.Tecnical_Status__c = false;
		update NewBillingItm;

		return NewBillingItm;

	}

}