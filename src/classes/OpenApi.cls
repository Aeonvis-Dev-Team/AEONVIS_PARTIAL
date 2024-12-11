public class OpenApi {

	public static List<Response> Listresponse = new List<Response> ();

	/**
	 * @description: Invia la fattura e righe (billing items) al sistema TIC. metodo richiamato da un flusso->avrà sempre 1 id Account nella lista di input 
	 * @param mtdAccountId: lista id dei billing items retrieve
	 */
	@InvocableMethod(label = 'Check IVA' description = 'Richiesta servizio OpenAPI validita PIVA' Callout = true)
	public static List<Response> checkPIVA(List<List<String>> mtdAccountID_PIVA) {

		try {
			System.debug('Acconut e iva da inviare al servizio ---> ' + mtdAccountID_PIVA[0] [0]);

			//retrieve dell'account, opportunita e billing items
			List<Account> WorkAcc = OpenApiHelper.retrieveAccountData(mtdAccountID_PIVA[0] [1]);

			Boolean Esito = OpenApiHelper.getCompanyInfo(mtdAccountID_PIVA[0] [1]);
			System.debug('Listresponse -- > ' + Listresponse);
			return Listresponse;

		} catch(Exception e) {
			Response response = new Response();
			response.success = false;
			response.error = 'Qualcosa è andato storto (catch). Messaggio errore ' + e.getMessage() + '\n' + 'Line: ' + e.getLineNumber();
			Listresponse.add(response);
			return Listresponse;
		}
	}

	public class Response {
		@InvocableVariable
		public Boolean success;
		@InvocableVariable
		public Integer RespStatusCode;
		@InvocableVariable
		public String message;
		@InvocableVariable
		public String error;
		@InvocableVariable
		public String taxCode;
		@InvocableVariable
		public String vatCode;
		@InvocableVariable
		public String companyName;
		@InvocableVariable
		public String streetName;
		@InvocableVariable
		public String town;
		@InvocableVariable
		public String province;
		@InvocableVariable
		public String DescProvince;
		@InvocableVariable
		public String zipCode;
		@InvocableVariable
		public String sdiCode;
		@InvocableVariable
		public String pec;

	}

}