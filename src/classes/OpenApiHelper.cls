public class OpenApiHelper {


	public static String Token = '';

	/*
	 * Retrieve dei dati per generare il file xml da inviare a TIC	
	 */
	public static List<Account> retrieveAccountData(string mtdAccountID_PIVA)
	{
		try {

			//retrieve dell'account, opportunita e billing items
			List<Account> WorkAcc = [SELECT Id, Company_name__c, Codice_SDI__c, VAT_number__c, BillingState, BillingStreet, BillingCity, BillingPostalCode
			                         FROM Account WHERE Id = :mtdAccountID_PIVA];

			return WorkAcc;
		} catch(Exception e) {
			OpenApi.Response response = new OpenApi.Response();
			response.success = false;
			response.error = 'Qualcosa è andato storto nel recupero dei dati dell\'account. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber();
			OpenApi.Listresponse.add(response);
			return null;
		}
	}

	public static Boolean getCompanyInfo(string PIVA)
	{
		try {


			if (LoginOpenApi() == false) { return false; }

			OpenAPI__c OpenAPICustom = OpenAPI__c.getOrgDefaults();
			String username = OpenAPICustom.Utente__c;
			String password = OpenAPICustom.ApiKey__c;
			Blob headerValue = Blob.valueOf(username + ':' + password);

			httpRequest httpRequest = new httpRequest();

			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setMethod('GET');
			request.setHeader('Content-Type', 'application/json');
			request.setEndpoint(OpenAPICustom.EndPointCheckIVA__c + 'IT-advanced/' + PIVA);
			request.setHeader('Authorization', 'Bearer ' + Token);
			request.setTimeout(120000);

			system.debug('REQUEST COMPANY INFO --- ' + request);
			HttpResponse response = http.send(request);
			system.debug('RESPONSE COMPANY INFO --- ' + response);

			// If the request is successful, parse the JSON response.
			if (response.getStatusCode() >= 200 && response.getStatusCode() <= 203) {
				OpenApiStructure.ResponseCompanyInfo ResponseCompany = (OpenApiStructure.ResponseCompanyInfo) JSON.deserialize(response.getBody(), OpenApiStructure.ResponseCompanyInfo.class);
				System.debug(ResponseCompany);

				OpenApiStructure.data CopmanyInfo = ResponseCompany.data[0];

				OpenApi.Response responseFlow = new OpenApi.Response();
				responseFlow.success = true;
				responseFlow.RespStatusCode = 200;
				responseFlow.error = '';
				responseFlow.companyName = (CopmanyInfo.companyName.length() > 80) ? CopmanyInfo.companyName.substring(0, 80) : CopmanyInfo.companyName;
				responseFlow.sdiCode = CopmanyInfo.sdiCode;
				responseFlow.vatCode = CopmanyInfo.vatCode;
				responseFlow.taxCode = CopmanyInfo.taxCode;
				responseFlow.province = CopmanyInfo.address.registeredOffice.province;
				responseFlow.DescProvince = GetProvince(CopmanyInfo.address.registeredOffice.province);
				responseFlow.streetName = CopmanyInfo.address.registeredOffice.streetName;
				responseFlow.town = CopmanyInfo.address.registeredOffice.town;
				responseFlow.zipCode = CopmanyInfo.address.registeredOffice.zipCode;
				responseFlow.pec = CopmanyInfo.pec;
				OpenApi.Listresponse.add(responseFlow);

			} else if (response.getStatusCode() == 400) {
				OpenApi.Response responseFlow = new OpenApi.Response();
				responseFlow.RespStatusCode = 400;
				responseFlow.success = false;
				responseFlow.error = 'Id, taxCode or vatCode required';
				OpenApi.Listresponse.add(responseFlow);
				return false;
			} else if (response.getStatusCode() == 402) {
				OpenApi.Response responseFlow = new OpenApi.Response();
				responseFlow.RespStatusCode = 402;
				responseFlow.success = false;
				responseFlow.error = 'Insufficient Credit in Wallet';
				OpenApi.Listresponse.add(responseFlow);
				return false;
			} else if (response.getStatusCode() == 406) {
				OpenApi.Response responseFlow = new OpenApi.Response();
				responseFlow.RespStatusCode = 406;
				responseFlow.success = false;
				responseFlow.error = 'taxCode/vatCode/id not valid';
				OpenApi.Listresponse.add(responseFlow);
				return false;
			}

			return true;
		} catch(Exception e) {
			OpenApi.Response response = new OpenApi.Response();
			response.success = false;
			response.error = 'Qualcosa è andato storto nel recupero delle informazioni della societa. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber();
			OpenApi.Listresponse.add(response);
			return false;
		}
	}

	public static Boolean LoginOpenApi()
	{
		try {

			OpenAPI__c OpenAPICustom = OpenAPI__c.getOrgDefaults();
			String username = OpenAPICustom.Utente__c;
			String password = OpenAPICustom.ApiKey__c;
			String ScopeCompany = OpenAPICustom.Scopes_Company__c; //test - company
			String ScopeProvince = OpenAPICustom.Scopes_PR__c; //test - cap
			Blob headerValue = Blob.valueOf(username + ':' + password);

			httpRequest httpRequest = new httpRequest();

			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setMethod('POST');
			request.setHeader('Content-Type', 'application/json');
			request.setEndpoint(OpenAPICustom.EndPointToken__c);
			request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(headerValue));
			request.setTimeout(120000);
			request.setBody('{"scopes": ["GET:' + ScopeCompany + '.openapi.com/*","GET:' + ScopeProvince + '.openapi.it/province"],"ttl": 180}');

			system.debug('REQUEST Login OpenAPI --- ' + request);
			HttpResponse response = http.send(request);
			system.debug('RESPONSE Login OpenAPI --- ' + response);

			// If the request is successful, parse the JSON response.
			if (response.getStatusCode() >= 200 && response.getStatusCode() <= 205) {
				OpenApiStructure.openApiLoginResponse LoginResponse = (OpenApiStructure.openApiLoginResponse) JSON.deserialize(response.getBody(), OpenApiStructure.openApiLoginResponse.class);
				System.debug('TOKEN RESPONSE -- ' + LoginResponse.token);
				Token = LoginResponse.token;
				System.debug(response);
			} else if (response.getStatusCode() >= 400 && response.getStatusCode() < 500) {
				OpenApi.Response responseFlow = new OpenApi.Response();
				responseFlow.success = false;
				responseFlow.error = 'Qualcosa è andato storto nella login al servizio OpenAPI. Messaggio errore: ' + response.getStatusCode() + '\n' + ' line: ' + response.getBody();
				OpenApi.Listresponse.add(responseFlow);

				return false;
			}

			return true;
		} catch(Exception e) {
			System.debug('Qualcosa è andato storto nel recupero del token di accesso. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());
			OpenApi.Response response = new OpenApi.Response();
			response.success = false;
			response.error = 'Qualcosa è andato storto nel recupero del token di accesso. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber();
			OpenApi.Listresponse.add(response);
			return false;
		}
	}


	public static string GetProvince(string CodProvincia)
	{

		OpenAPI__c OpenAPICustom = OpenAPI__c.getOrgDefaults();

		CodProvincia = (String.valueOf(OpenAPICustom.EndPointPR__c).contains('test') ? 'AG' : CodProvincia);
		System.debug('CodProvincia --> ' + CodProvincia);

		httpRequest httpRequest = new httpRequest();

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setHeader('Content-Type', 'application/json');
		request.setEndpoint(OpenAPICustom.EndPointPR__c + 'province/' + CodProvincia);
		request.setHeader('Authorization', 'Bearer ' + Token);
		request.setTimeout(120000);

		system.debug('REQUEST COMPANY INFO --- ' + request);
		HttpResponse response = http.send(request);
		system.debug('RESPONSE COMPANY INFO --- ' + response);

		// If the request is successful, parse the JSON response.
		if (response.getStatusCode() >= 200 && response.getStatusCode() <= 203) {
			//if (Test.isRunningTest() == true) { response.setBody('{"data": [{"sigla": "AG","provincia": "Agrigento","superficie": 3052.59,"residenti": 446081,"num_comuni": 43,"istat": "084","regione": "Sicilia"}],"success": true,"message": "","error": null}'); }
			OpenApiStructure.provinciaResponse Provincia = (OpenApiStructure.provinciaResponse) JSON.deserialize(response.getBody(), OpenApiStructure.provinciaResponse.class);
			System.debug(Provincia);

			return Provincia.data.provincia;

		} else {
			return '';
		}
	}
}