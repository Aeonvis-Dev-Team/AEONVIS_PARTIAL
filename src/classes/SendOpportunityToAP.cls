public class SendOpportunityToAP {


	public static String AccessToken = '';
	public static String instanceUrl = '';
	public static String access_token = '';

	@Future(Callout = true)
	public static void sendOppoID(id oppId) {

		try {

			AP_Login();

			String jsonToSend = CreaJSONOppo(oppId);
			System.debug('jsonToSend --- ' + jsonToSend);

			//compongo la chiamata
			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint(instanceUrl + '/services/apexrest/Opportunity/SendOpportunity');
			request.setMethod('POST');
			request.setHeader('Content-Type', 'application/json');
			request.setHeader('Authorization', 'Bearer ' + AccessToken);
			request.setBody(jsonToSend);
			//invio
			system.debug('request SEND OPP --- ' + request);
			HttpResponse response = http.send(request);
			system.debug('response SEND OPP --- ' + response);

		} catch(Exception e) {

			System.debug('CATCH sendOppoID MESSAGE --- ' + e.getMessage());
			System.debug('CATCH sendOppoID LINE --- ' + e.getLineNumber());
			System.debug('CATCH sendOppoID CAUSE --- ' + e.getCause());
			System.debug('CATCH sendOppoID Stack --- ' + e.getStackTraceString());
		}
	}

	private static string CreaJSONOppo(String oppId)
	{
		Opportunity Oppo = [SELECT id, Name, CloseDate, AccountId, Account.Name, Account.Id, Account.Codice_SDI__c, Line_of_Business__c, Code__c,
		                    Account.BillingCity, Account.BillingCountry, Account.BillingPostalCode, Account.BillingState, Account.BillingStreet,
		                    Account.ShippingCity, Account.ShippingCountry, Account.ShippingPostalCode, Account.ShippingState, Account.ShippingStreet,
		                    Amount, Expected_Margin__c, Contract_type__c, Engagement_Type__c
		                    FROM Opportunity WHERE id = :oppId];

		OppoIntegrationStructure.records Opportunita = new OppoIntegrationStructure.records();
		OppoIntegrationStructure.Account Acc = new OppoIntegrationStructure.Account();
		OppoIntegrationStructure.BillingAddress BillingAddress = new OppoIntegrationStructure.BillingAddress();
		OppoIntegrationStructure.ShippingAddress ShippingAddress = new OppoIntegrationStructure.ShippingAddress();


		BillingAddress.city = Oppo.Account.BillingCity;
		BillingAddress.country = Oppo.Account.BillingCountry;
		BillingAddress.postalCode = Oppo.Account.BillingPostalCode;
		BillingAddress.state = Oppo.Account.BillingState;
		BillingAddress.street = Oppo.Account.BillingStreet;

		ShippingAddress.city = Oppo.Account.ShippingCity;
		ShippingAddress.country = Oppo.Account.ShippingCountry;
		ShippingAddress.postalCode = Oppo.Account.ShippingPostalCode;
		ShippingAddress.state = Oppo.Account.ShippingState;
		ShippingAddress.street = Oppo.Account.ShippingStreet;

		Acc.Id = Oppo.AccountId;
		Acc.Name = Oppo.Account.Name;
		Acc.Codice_SDIXYZ = Oppo.Account.Codice_SDI__c;
		Acc.BillingAddress = BillingAddress;
		Acc.ShippingAddress = ShippingAddress;

		Opportunita.Id = Oppo.Id;
		Opportunita.Name = Oppo.Name;
		Opportunita.CloseDate = Oppo.CloseDate;
		Opportunita.Amount = Oppo.Amount;
		Opportunita.Ammontare_ArrotondatoXYZ = Oppo.Amount;
		Opportunita.MargineXYZ = Oppo.Expected_Margin__c;

		Opportunita.Expected_MarginXYZ = Oppo.Expected_Margin__c;
		Opportunita.Line_of_BusinessXYZ = Oppo.Line_of_Business__c;
		Opportunita.Contract_typeXYZ = Oppo.Contract_type__c;
		Opportunita.Engagement_TypeXYZ = Oppo.Engagement_Type__c;
		Opportunita.Account = Acc;
		Opportunita.CodeXYZ = Oppo.Code__c;

		string JSONString = JSON.serialize(Opportunita, true);

		System.debug('OPPO JSON ---- ' + JSONString);

		return JSONString;
	}

	//funzione che si occupa di fare la login sulla ORG AP
	public static void AP_Login()
	{
		try {
			//get dei dati dalle impostazioni personalizzate
			string EndPoint = '';
			AccessToken = '';
			LoginIntegrazioneAP__c Credenziali = LoginIntegrazioneAP__c.getOrgDefaults();

			System.debug('Credenziali -- ' + Credenziali);
			EndPoint = Credenziali.EndPointLogin__c;
			EndPoint += 'client_id=' + Credenziali.ConsumerKey__c;
			EndPoint += '&client_secret=' + Credenziali.ClientSecret__c;
			EndPoint += '&refresh_token=' + Credenziali.RefreshToken__c;

			//compongo la chiamata
			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint(EndPoint);
			request.setMethod('GET');
			request.setHeader('Content-Type', 'application/json');
			request.setTimeout(10000);


			//invio
			HttpResponse response = http.send(request);
			system.debug('LOGIN RESPONSE -------- ' + response);

			// If the request is successful, parse the JSON response.
			if (response.getStatusCode() >= 200 && response.getStatusCode() <= 205) {
				OppoIntegrationStructure.LoginAPResponse LoginResponse = (OppoIntegrationStructure.LoginAPResponse) JSON.deserialize(response.getBody(), OppoIntegrationStructure.LoginAPResponse.class);
				System.debug('TOKEN RESPONSE -- ' + LoginResponse.access_token);
				AccessToken = LoginResponse.access_token;
				instanceUrl = LoginResponse.instance_url;
				System.debug(response);
			} else if (response.getStatusCode() >= 400 && response.getStatusCode() < 500) {

			} else {

			}
		} catch(Exception e) {

		}
	}

}