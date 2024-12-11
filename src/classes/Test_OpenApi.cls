@isTest
public class Test_OpenApi {
	@TestVisible
	public static String testing;

	@TestSetup
	private static void dataFactory() {
		IntegrationTIC__c im = DataFactory.createCustomSettingsTIC();
		OpenAPI__c OpenApiCustom = DataFactory.createCustomSettingsOpenAPI();
		//List<account> Acc = DataFactory.createAccount(1, 'Luca');
		account AccPartners = DataFactory.createAccountPartners('Luca Partners');
	}

	@isTest
	private static void CallAPI200()
	{
		List<List<String>> mtdAccountID_PIVA = new List<List<String>> ();

		Account Acc = [SELECT Id FROM Account LIMIT 1];

		mtdAccountID_PIVA.add(new List<String> { Acc.id, '12345698741' });

		System.debug(mtdAccountID_PIVA);

		Test.startTest();
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		testing = 'CheckIVA200';
		OpenApi.checkPIVA(mtdAccountID_PIVA);
		OpenApi.checkPIVA(null);
		Test.stopTest();
	}

	@isTest
	private static void CallAPI400()
	{
		List<List<String>> mtdAccountID_PIVA = new List<List<String>> ();

		Account Acc = [SELECT Id FROM Account LIMIT 1];

		mtdAccountID_PIVA.add(new List<String> { Acc.id, '12345698741' });

		System.debug(mtdAccountID_PIVA);

		Test.startTest();
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		testing = 'CheckIVA400';
		OpenApi.checkPIVA(mtdAccountID_PIVA);

		testing = 'CheckIVA402';
		OpenApi.checkPIVA(mtdAccountID_PIVA);

		testing = 'CheckIVA406';
		OpenApi.checkPIVA(mtdAccountID_PIVA);
		Test.stopTest();
	}

}