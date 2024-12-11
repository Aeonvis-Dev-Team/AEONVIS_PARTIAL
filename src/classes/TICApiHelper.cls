public class TICApiHelper {
	
	public static Integer countRiga = 0;
	
	/*
	 * ------------------------------------------------------- INVIO BOZZA ------------------------------------------------------------
	 */

	/*
	 * Retrieve dei dati per generare il file xml da inviare a TIC	
	 */
	public static List<Billing_Item__c> retrieveData(List<Id> mtdBillingItemId)
	{
		try {		
											//retrieve dell'account, opportunita e billing items
			List<Billing_Item__c> WorkBI = [SELECT Id, Bill_to__r.name, Bill_to__r.VAT_number__c, Bill_to__r.P_Iva_C_F__c,Bill_to__r.Fiscal_code__c,
											Bill_to__r.Codice_SDI__c,Order_Number__c,Data_Ordine__c, Billing_date__c, Bill_to__r.Company_name__c, Bill_to__r.BillingCity,
											Bill_to__r.BillingCountry, Bill_to__r.BillingCountryCode, Bill_to__r.BillingPostalCode,
											Bill_to__r.BillingState, Bill_to__r.BillingStateCode, Bill_to__r.BillingStreet,Billing_item_total__c,
											Bill_to__r.PEC__c, Opportunity__r.Order_Number__c, Data_scadenza__c, Opportunity__r.TR_Project_ID__c, Bill_to__r.Phone,
											Name, VAT_Code__c, Billing_amount__c, Billing_item_description_for_tic__c, Out_of_pocket_desc__c, Out_of_pocket_amount__c,
											Bill_to__r.Declaration_of_intent__c, Bill_to__r.Declaration_intent_number__c, Opportunity__r.Code__c, Entrata_merci__c, 
											Opportunity__r.Order_Date__c,Bill_to__r.Data_Inizio_Dichiarazione_di_Intenti__c, Bill_to__r.Supplier_Code__c,
											Bill_to__r.Cap_Formula__c
			                                FROM Billing_Item__c WHERE Id = :mtdBillingItemId[0] OR Bill_with__c = :mtdBillingItemId[0] ORDER BY Bill_with__c];
			System.debug('WorkBI + :'+WorkBI);								

			return WorkBI;
		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);
			TICApi.gblReturnMessage += 'Qualcosa è andato storto nel recupero dei dati da inviare. Messaggio errore: ' + e.getMessage() + '\n' + ' line: ' + e.getLineNumber();
			System.debug('Qualcosa è andato storto nel recupero dei dati da inviare. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());
			return null;
		}
	}

	/*
	 * Generazione del file XML da inviare per generare la bozza
	 */
	public static Boolean generaXML(List<Billing_Item__c> WorkBI)
	{
		try {
			Boolean Esito = true;
			TICstructure.Doc Doc = new TICstructure.Doc();
			TICstructure.Documenti Docs = new TICstructure.Documenti();
			TICstructure.Documento doctosend = new TICstructure.Documento();
			List<TICstructure.Documento> listOfDoc = new List<TICstructure.Documento> ();
			TICstructure.scadenzeContenitore scadenzeContenitore = new TICstructure.scadenzeContenitore ();
			List<TICstructure.scadenza> scadenze = new List<TICstructure.scadenza> ();
			TICstructure.righeContenitore righeContenitore = new TICstructure.righeContenitore ();
			List<TICstructure.riga> riga = new List<TICstructure.riga> ();

			//Entrata Merci - NR Ordine - Nr opportunita - dichiarazione intenti
			Esito = creaRigheDescrittive(riga, WorkBI);

			//valorizzazione della testata
			Esito = creaTestata(doctosend, WorkBI);
						
			string VAT_CODE = WorkBI[0].VAT_Code__c;

			for (Billing_Item__c BI : WorkBI)
			{
				//valorizzazione delle righe
				if (esito == true) { Esito = creaRighe(riga, BI, VAT_CODE); } else { return false; }

				//valorizzazione della riga descrittiva
				if (esito == true) { Esito = creaRigaDescrittiva(riga, BI); } else { return false; }

				//valorizzazione della riga delle spese
				if (esito == true) { Esito = creaRigaSpese(riga, BI, VAT_CODE); } else { return false; }
			
			}

			//valorizzazione della riga scadenza
			if (esito == true) { Esito = creaRigaScadenza(scadenze, WorkBI); } else { return false; }

			////valorizzazione delle righe
			//if (esito == true) { Esito = creaRighe(riga, WorkBI); } else { return false; }

			////valorizzazione della riga scadenza
			//if (esito == true) { Esito = creaRigaScadenza(scadenze, WorkBI); } else { return false; }

			////valorizzazione della riga descrittiva
			//if (esito == true) { Esito = creaRigaDescrittiva(riga, WorkBI); } else { return false; }

			////valorizzazione della riga delle spese
			//if (esito == true) { Esito = creaRigaSpese(riga, WorkBI); } else { return false; }

			//vengono messi insieme tutti i dati che comporranno l'XML
			righeContenitore.riga = riga;
			scadenzeContenitore.scadenza = scadenze;
			doctosend.scadenze = scadenzeContenitore;
			doctosend.righe = righeContenitore;
			listOfDoc.add(doctosend);

			Docs.documento = listOfDoc;
			Doc.Documenti = Docs;

			if (esito == true) { Esito = creaEdecodificaXML(Doc); } else { return false; }

			return esito;
		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);
			TICApi.gblReturnMessage += 'Qualcosa è andato storto nella creazione del XML. Messaggio errore: ' + e.getMessage() + '\n' + ' line: ' + e.getLineNumber();
			System.debug('Qualcosa è andato storto nella creazione del XML. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());
			return false;
		}
	}

	/*
	 * valorizzazione della testata da inviare a TIC
	 */
	public static Boolean creaTestata(TICstructure.Documento doctosend, List<Billing_Item__c> WorkBI)
	{

		try {
			IntegrationTIC__c IntegrationTIC = IntegrationTIC__c.getOrgDefaults();
			Billing_Item__c DatiTestata = WorkBI[0];
			Opportunity Oppo = DatiTestata.Opportunity__r;
			Account Acc = DatiTestata.Bill_to__r;
			
			Datetime data = Date.today();

System.debug(data.format('YY'));

			//doctosend.stato = '0';
			doctosend.partitaivatic =  IntegrationTIC.P_IVA_Emittente__c;//Acc.P_Iva_C_F__c;
			doctosend.SDI = '1';//(String.isNotBlank(Acc.BillingCountryCode) && Acc.BillingCountryCode == 'IT') ? '1' : '0';
			doctosend.coddestinatario = (String.isNotBlank(Acc.BillingCountryCode) && Acc.BillingCountryCode == 'IT') ? Acc.Codice_SDI__c : null;
			doctosend.tipodocumento = 'BZ';
			//doctosend.serie = String.valueOf(Date.today().year()).substring(2,4); //(String.isNotBlank(Acc.BillingCountryCode) && Acc.BillingCountryCode == 'IT') ? IntegrationTIC.Serie_ITA__c : IntegrationTIC.Serie_Est__c;
			doctosend.serie = (String.isNotBlank(Acc.BillingCountryCode) && Acc.BillingCountryCode == 'IT') ? (String.valueOf(data.format('YY')) + '/' + IntegrationTIC.Serie_ITA__c) : (String.valueOf(data.format('YY')) + '/' + IntegrationTIC.Serie_Est__c);
			
			//Modifica del 14/11/2024: viene preso il campo dataordine editatbile a video
			doctosend.data = (String.isNotBlank(String.valueOf(DatiTestata.Billing_date__c)) == true) ? Datetime.valueOf((Datetime) DatiTestata.Billing_date__c).format('dd/MM/yyyy') : String.valueOf(Datetime.now().format('dd/MM/yyyy'));
			//doctosend.data = (String.isNotBlank(String.valueOf(DatiTestata.Data_Ordine__c)) == true) ? Datetime.valueOf((Datetime) DatiTestata.Data_Ordine__c).format('dd/MM/yyyy') : String.valueOf(Datetime.now().format('dd/MM/yyyy'));
			
			doctosend.forgiu = 'AZI';
			doctosend.ragionesociale = Acc.Company_name__c;
			doctosend.idpaese = Acc.BillingCountryCode;
			doctosend.pecdestinatario = (String.isNotBlank(Acc.PEC__c) ? Acc.PEC__c : null);
			doctosend.nazione = Acc.BillingCountryCode;
			doctosend.comune = Acc.BillingCity;
			doctosend.indirizzo = Acc.BillingStreet;
			doctosend.cap = Acc.Cap_Formula__c;//Acc.BillingPostalCode; //
			doctosend.provincia = (String.isNotBlank(Acc.BillingStateCode)) ? Acc.BillingStateCode : null ;
			doctosend.addebitaBollo = '1';

			if (DatiTestata.VAT_Code__c == 'N030201' || DatiTestata.VAT_Code__c == 'N020202' || DatiTestata.VAT_Code__c == 'N060201' ) {
				doctosend.addebitaBollo = '0';	
				doctosend.Bollo = 2.00;			
				doctosend.IvaBollo = 'N010100';
			}
			doctosend.telefono = (String.isNotBlank(Acc.Phone) ? Acc.Phone : null);
			doctosend.idcodice = Acc.VAT_number__c;			
			doctosend.codicefiscale = (String.isNotBlank(Acc.Fiscal_code__c) ? Acc.Fiscal_code__c : null);

			System.debug('Testata ---> ' + doctosend);
			return true;
		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);
			TICApi.gblReturnMessage += 'Qualcosa è andato storto nella creazione della testata del file XML. Messaggio errore: ' + e.getMessage() + '\n' + ' line: ' + e.getLineNumber();
			System.debug('Qualcosa è andato storto nella creazione della testata del file XML. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());
			return false;
		}
	}

	/*
	 * valorizzazione delle righe di servizio da inviare a TIC
	 */
	public static Boolean creaRighe(List<TICstructure.riga> righe, Billing_Item__c WorkBI, string VAT_CODE)
	{
		try {
			if(WorkBI.Billing_amount__c>0){
				Decimal SummPrice = 0;
				countRiga += 10;
				TICstructure.riga riga = new TICstructure.riga();
				riga.numeroriga = countRiga;
				riga.codicearticolo = WorkBI.Opportunity__r.TR_Project_ID__c;
				riga.descrizioneart = WorkBI.Name;
				riga.codiva = VAT_CODE; //WorkBI.VAT_Code__c;
				riga.unimis = 'N';
				riga.quantita = '1';
				riga.prezzo = String.valueOf(WorkBI.Billing_amount__c);
				righe.add(riga);
				System.debug('riga servizio---> ' + riga);
			} return true;
			
		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);
			TICApi.gblReturnMessage += 'Qualcosa è andato storto nella creazione della righe di servizio del file XML. Messaggio errore: ' + e.getMessage() + '\n' + ' line: ' + e.getLineNumber();
			System.debug('Qualcosa è andato storto nella creazione della righe di servizio del file XML. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());
			return false;
		}
	}

	/*
	 * valorizzazione delle righe di scadenza da inviare a TIC
	 */
	public static Boolean creaRigaScadenza(List<TICstructure.scadenza> scadenze, List<Billing_Item__c> WorkBI)
	{
		try {

			TICstructure.scadenza scadenza = new TICstructure.scadenza();

			Decimal SummPrice = 0;
			for (Integer i = 0; i<WorkBI.size(); i++) {
				SummPrice += WorkBI[i].Billing_item_total__c;
			}

			if(WorkBI[0].VAT_Code__c == '22')
			{
				SummPrice = (SummPrice * 1.22).setScale(2, System.RoundingMode.HALF_UP);
			}


			scadenza.dataScadenza = (WorkBI[0].Data_scadenza__c != null) ? Datetime.valueOf((Datetime) WorkBI[0].Data_scadenza__c).format('dd/MM/yyyy') : Datetime.now().addMonths(1).format('dd/MM/yyyy');
			scadenza.importoRata = SummPrice;
			scadenza.tipoPagamento = 'TP06';

			scadenze.add(scadenza);

			System.debug('Scadenza ---> ' + scadenza);
			return true;
		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);
			TICApi.gblReturnMessage += 'Qualcosa è andato storto nella creazione della righe di servizio del file XML. Messaggio errore: ' + e.getMessage() + '\n' + ' line: ' + e.getLineNumber();
			System.debug('Qualcosa è andato storto nella creazione della righe di servizio del file XML. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());
			return false;
		}
	}

	/*
	 * valorizzazione della riga descrittiva da inviare a TIC
	 */
	public static Boolean creaRigaDescrittiva(List<TICstructure.riga> righe, Billing_Item__c WorkBI)
	{
		try {

			if(String.isNotBlank(WorkBI.Billing_item_description_for_tic__c) == true)
			{
				IntegrationTIC__c IntegrationTIC = IntegrationTIC__c.getOrgDefaults();
				
				countRiga += 10;
				TICstructure.riga riga = new TICstructure.riga();
				riga.numeroriga = countRiga;
				riga.codicearticolo = '.';
				riga.descrizioneart = (String.isNotBlank(WorkBI.Billing_item_description_for_tic__c)) ? WorkBI.Billing_item_description_for_tic__c.replace('\n',' ') : '';				

				righe.add(riga);
				System.debug('riga descrittiva---> ' + riga);
			}
			
			return true;
		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);
			TICApi.gblReturnMessage += 'Qualcosa è andato storto nella creazione della righe di servizio del file XML. Messaggio errore: ' + e.getMessage() + '\n' + ' line: ' + e.getLineNumber();
			System.debug('Qualcosa è andato storto nella creazione della righe di servizio del file XML. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());
			return false;
		}
	}
	
	/*
	 * Creazione delle righe descrittire se presenti i seguenti valori
	 * 1 - Entrata merci su Billing Item
	 * 2 - Nr Ordine su opportunita
	 * 3 - Nr Opportunita su opportunita
	 * 4 - Cod. dichiarazione di intenti su account
	 */
	public static Boolean creaRigheDescrittive(List<TICstructure.riga> righe, List<Billing_Item__c> WorkBI){
		try {

			IntegrationTIC__c IntegrationTIC = IntegrationTIC__c.getOrgDefaults();
			Billing_Item__c DatiTestata = WorkBI[0];
			Opportunity Oppo = DatiTestata.Opportunity__r;
			Account Acc = DatiTestata.Bill_to__r;

			//numero ordine come riga descrittiva
			if(String.isNotBlank(DatiTestata.Order_Number__c) == true)
			{
				string DataOrdine = (String.isNotBlank(String.valueOf(DatiTestata.Data_Ordine__c))) ? ' del ' + String.valueOf(Datetime.valueOf((Datetime) DatiTestata.Data_Ordine__c).format('dd/MM/yyyy')) : '';
				countRiga += 10;
				TICstructure.riga riga = new TICstructure.riga();
				riga.numeroriga = countRiga;
				riga.codicearticolo = '.';
				riga.descrizioneart = (String.isNotBlank(DatiTestata.Order_Number__c)) ? 'Nr Ordine: ' + DatiTestata.Order_Number__c.replace('\n',' ') + DataOrdine : '';
				//riga.descrizioneartsupp = (String.isNotBlank(Oppo.Order_Number__c)) ? 'Nr Ordine: ' + Oppo.Order_Number__c.replace('\n',' ') : '';			

				righe.add(riga);
			}

			//entrata merci come riga descrittiva
			if(String.isNotBlank(DatiTestata.Entrata_merci__c) == true)
			{
				
				countRiga += 10;
				TICstructure.riga riga = new TICstructure.riga();
				riga.numeroriga = countRiga;
				riga.codicearticolo = '.';
				riga.descrizioneart = (String.isNotBlank(DatiTestata.Entrata_merci__c)) ? 'Entrata Merci: ' + DatiTestata.Entrata_merci__c.replace('\n',' ') : '';
				//riga.descrizioneartsupp = (String.isNotBlank(DatiTestata.Entrata_merci__c)) ? 'Entrata Merci: ' + DatiTestata.Entrata_merci__c.replace('\n',' ') : '';			

				righe.add(riga);
			}

			//numero opportunita come riga descrittiva
			if(String.isNotBlank(Oppo.Code__c) == true)
			{
				
				countRiga += 10;
				TICstructure.riga riga = new TICstructure.riga();
				riga.numeroriga = countRiga;
				riga.codicearticolo = '.';
				riga.descrizioneart = (String.isNotBlank(Oppo.Code__c)) ? 'Cod. Opportunita: ' + Oppo.Code__c.replace('\n',' ') : '';
				//riga.descrizioneartsupp = (String.isNotBlank(Oppo.Code__c)) ? 'Cod. Opportunita: ' + Oppo.Code__c.replace('\n',' ') : '';			

				righe.add(riga);
			}
			
			//codice dichiarazione di intenti come riga descrittiva
			if(String.isNotBlank(Acc.Declaration_intent_number__c) == true && Date.today() < Acc.Declaration_of_intent__c && Acc.Declaration_of_intent__c != null )
			{	
				
				countRiga += 10;
				TICstructure.riga riga = new TICstructure.riga();
				riga.numeroriga = countRiga;
				riga.codicearticolo = '.';
				riga.descrizioneart = (String.isNotBlank(Acc.Declaration_intent_number__c) && Acc.Data_Inizio_Dichiarazione_di_Intenti__c != null) ? 'Nr Dich. Intenti: ' + Acc.Declaration_intent_number__c.replace('\n',' ')+' - del ' + Acc.Data_Inizio_Dichiarazione_di_Intenti__c.format() :
				(String.isNotBlank(Acc.Declaration_intent_number__c) && Acc.Data_Inizio_Dichiarazione_di_Intenti__c == null) ? 'Nr Dich. Intenti: ' + Acc.Declaration_intent_number__c.replace('\n',' ')
				: '';
				righe.add(riga);
			}


			if(String.isNotBlank(Acc.Supplier_Code__c) == true){
				countRiga += 10;
				TICstructure.riga riga = new TICstructure.riga();
				riga.numeroriga = countRiga;
				riga.codicearticolo = '.';
				riga.descrizioneart = 'Codice Fornitore: ' + Acc.Supplier_Code__c.replace('\n',' ');
				righe.add(riga);
			}
			
			return true;
		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);
			TICApi.gblReturnMessage += 'Qualcosa è andato storto nella creazione della righe di servizio del file XML. Messaggio errore: ' + e.getMessage() + '\n' + ' line: ' + e.getLineNumber();
			System.debug('Qualcosa è andato storto nella creazione della righe di servizio del file XML. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());
			return false;
		}
	}

	/*
	 * valorizzazione della riga descrittiva da inviare a TIC
	 */
	public static Boolean creaRigaSpese(List<TICstructure.riga> righe, Billing_Item__c WorkBI, string VAT_CODE)
	{
		try {

			if (WorkBI.Out_of_pocket_amount__c > 0)
			{
				countRiga += 10;
				TICstructure.riga riga = new TICstructure.riga();
				riga.numeroriga = countRiga;
				riga.codicearticolo = WorkBI.Opportunity__r.TR_Project_ID__c; //'Spese';
				riga.descrizioneart = (String.isNotBlank(WorkBI.Out_of_pocket_desc__c) == true ) ? WorkBI.Out_of_pocket_desc__c : 'Spese di trasferta';
				riga.codiva = VAT_CODE; //WorkBI.VAT_Code__c;
				riga.unimis = 'N';
				riga.quantita = '1';
				riga.prezzo =  String.valueOf(WorkBI.Out_of_pocket_amount__c);

				righe.add(riga);
				System.debug('riga spese---> ' + riga);
			}

			return true;
		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);
			TICApi.gblReturnMessage += 'Qualcosa è andato storto nella creazione della righe di servizio del file XML. Messaggio errore: ' + e.getMessage() + '\n' + ' line: ' + e.getLineNumber();
			System.debug('Qualcosa è andato storto nella creazione della righe di servizio del file XML. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());
			return false;
		}
	}

	/*
	 * serializzazione in JSON, trasformazione in XML e decodifica in base64
	 */
	public static Boolean creaEdecodificaXML(TICstructure.Doc Doc)
	{
		try {
			string jsonToSend = JSON.serialize(Doc, true);

			XMLSerializer serializer = new XMLSerializer();
			string jsonString = serializer.jsonToXML(jsonToSend);

			System.debug('JSON da trasformare in XML --->' + jsonString);
			Blob binaryData = Blob.valueOf(jsonString);

			// Encode the Blob as a Base64 string
			TICApi.base64DocToSend = EncodingUtil.base64Encode(binaryData);
			System.debug('XML da inviare --->' + TICApi.base64DocToSend);

			return true;
		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);
			TICApi.gblReturnMessage += 'Qualcosa è andato storto nella decodifica XML. Messaggio errore: ' + e.getMessage() + '\n' + ' line: ' + e.getLineNumber();
			System.debug('Qualcosa è andato storto nella decodifica XML. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());
			return false;
		}
	}

	/*
	 * Invio della fattura a TIC
	 */
	public static Boolean SendToTIC()
	{
		try {

			System.debug('base64DocToSend ----> ' + TICApi.base64DocToSend);
			
			IntegrationTIC__c IntegrationTIC = IntegrationTIC__c.getOrgDefaults();
			httpRequest httpRequest = new httpRequest();
			//httpRequest.setHeader('Content-type', 'application/XML');
			Http httpObject = new Http();
			HttpResponse httpResponse;
			httpRequest.setHeader('Content-type', 'text/xml');
			httpRequest.setEndpoint(IntegrationTIC.Endpoint__c + ':443/servlet/su_fimport_draft_ws');
			httpRequest.setMethod('POST');
			httpRequest.setTimeout(120000);
			httpRequest.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:su="http://su_fimport_draft_ws.ws.localhost/">'+
								'<soapenv:Header/>'+
								   '<soapenv:Body>'+
									  '<su:su_fimport_draft_ws_Run>'+
										 '<su:m_UserName>' + IntegrationTIC.UserName__c + '</su:m_UserName>'+
										 '<su:m_Password>' + IntegrationTIC.Password__c + '</su:m_Password>'+
										 '<su:p_DocBase64>' + TICApi.base64DocToSend + '</su:p_DocBase64>'+
									  '</su:su_fimport_draft_ws_Run>'+
								   '</soapenv:Body>'+
							'</soapenv:Envelope>');
			
			httpResponse = httpObject.send(httpRequest);
			system.debug('Response Send TIC - ' + httpResponse.getStatusCode() + ' -- ' + httpResponse.getBody() );
			if (httpResponse.getStatusCode() == 200) {
				system.debug('Response 200 - ' + httpResponse.getBody());

				XMLSerializer serializer = new XMLSerializer();

				string jsonString = serializer.xmlToJSON(httpResponse.getBody());	
				string Ottimizzato = jsonString.replace('\\','').replace('"[', '[').replace(']"', ']').replace('\\','').replace('return','returnXYZ');
				System.debug('Deserialize Ottimizzato --- ' + Ottimizzato);
				TICApi.res = (TICstructure.ResponseTic) JSON.deserialize( Ottimizzato, TICstructure.ResponseTic.class);
				System.debug(TICApi.res);				

				System.debug('RESPONSE ---> ' + TICApi.res.Envelope.Body.su_fimport_draft_ws_RunResponse.returnXYZ[0]);				
				System.debug('RESPONSE dettaglio ---> ' + TICApi.res.Envelope.Body.su_fimport_draft_ws_RunResponse.returnXYZ[0].dettaglio);
				TICApi.gblReturnMessage += TICApi.res.Envelope.Body.su_fimport_draft_ws_RunResponse.returnXYZ[0].dettaglio;

				return true;
			} else {
				system.debug('Response - ' + httpResponse.getBody());
				TICApi.gblReturnMessage += 'Qualcosa è andato storto nell\'invio della fattura a TIC (Code <> 200). Messaggio errore: ' + httpResponse.getBody();			
				return false;
			}

		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);
			TICApi.gblReturnMessage += 'Qualcosa è andato storto nell\'invio della fattura a TIC. Messaggio errore: ' + e.getMessage() + '\n' + ' line: ' + e.getLineNumber();
			System.debug('Qualcosa è andato storto nell\'invio della fattura a TIC. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());
			return false;
		}
	}

	/*
	 * ------------------------------------------------------- FINE INVIO BOZZA ------------------------------------------------------------
	 */



	 /*
	  *	------------------------------------------------------- RETRIEVE STATO FATTURA ------------------------------------------------------------
	  */

	/*
	 * Generazione del file per la richiesta dello stato
	 */
	public static string generaXMLRetrieveStatus(List<Billing_Item__c> ListWorkBI)
	{
		Billing_Item__c LogBI = null;

		try {
			
			TICstructure.StatusDoc Status = new TICstructure.StatusDoc();
			TICstructure.StatusDocumenti StatusDocumento = new TICstructure.StatusDocumenti();
			List<TICstructure.StatusDocumento> ListaSingoliDoc = new List<TICstructure.StatusDocumento>();

			for(Billing_Item__c WorkBI: ListWorkBI)
			{
				LogBI = WorkBI;

				//se numero fattura è valorizzato cerco per numero fattura altrimenti per numero bozza
				if(WorkBI.Bill_with__c == null && String.isNotBlank(WorkBI.TIC_invoice_no__c) == true)
				{
					System.debug('NEL FOR');
					TICstructure.StatusDocumento getStatus = new TICstructure.StatusDocumento();

					getStatus.tipodocumento = 'FA';
					getStatus.numtic = WorkBI.TIC_invoice_no__c;
					getStatus.data = Datetime.valueOf((Datetime) WorkBI.Data_Ordine__c).format('dd/MM/yyyy');
					getStatus.ragionesociale = WorkBI.Bill_to__r.Company_name__c;	
					ListaSingoliDoc.add(getStatus);		
				}else if(WorkBI.Bill_with__c == null && String.isNotBlank(WorkBI.TIC_draft_no__c) == true)
				{
					System.debug('NEL FOR');
					TICstructure.StatusDocumento getStatus = new TICstructure.StatusDocumento();

					getStatus.tipodocumento = 'BZ';
					getStatus.numtic = WorkBI.TIC_draft_no__c;
					getStatus.data = Datetime.valueOf((Datetime) WorkBI.Data_Ordine__c).format('dd/MM/yyyy');
					getStatus.ragionesociale = WorkBI.Bill_to__r.Company_name__c;	
					ListaSingoliDoc.add(getStatus);		
				}
			}
	
			StatusDocumento.documento = ListaSingoliDoc;
			Status.Documenti = StatusDocumento;

			string JSONString = JSON.serialize(Status, true);			
			System.debug('JSON STATUS ---> ' + JSONString);

			XMLSerializer serializer = new XMLSerializer();
			string XMLSerializzato = serializer.jsonToXML(JSONString);
			System.debug('XML STATUS ---> ' + XMLSerializzato);

			return XMLSerializzato;
		} catch(Exception e) {			
			System.debug('Qualcosa è andato storto nella creazione del XML per richiesta stato. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());

			string NameLog = 'generaXML Status ' + String.valueOf(Datetime.now().format('dd/MM/yyyy'));
			string Billing = LogBI.Name + ' - ' + LogBI.Opportunity__r.Name;
			string description = 'Qualcosa è andato storto nella creazione del XML per il Billint items ' + Billing + ' per richiesta stato. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber();
			TIC_Custom_Log__c log = CustomLog.log(NameLog,description,'Errore genera XML stato', 'TICApiHelper - generaXMLRetrieveStatus');
			BatchSincroStatiInvoice.TICLog.add(log);

			return null;
		}
	}

	/*
	 * RETRIEVE DELLO STATO DA TIC
	 */
	public static Boolean GetStatusFromTIC(String XML)
	{
		string XMLToSend;
		try {
			
			Blob binaryData = Blob.valueOf(XML);
			string base64DocStatus = EncodingUtil.base64Encode(binaryData);
			XMLToSend = base64DocStatus;
			System.debug('XML CODIFICATO da inviare --->' + base64DocStatus);

			IntegrationTIC__c IntegrationTIC = IntegrationTIC__c.getOrgDefaults();
			httpRequest httpRequest = new httpRequest();
			//httpRequest.setHeader('Content-type', 'application/XML');
			Http httpObject = new Http();
			HttpResponse httpResponse;
			httpRequest.setHeader('Content-type', 'text/xml');
			httpRequest.setEndpoint(IntegrationTIC.Endpoint__c + ':443/servlet/su_fgetdett_draft_ws');
			httpRequest.setMethod('POST');
			httpRequest.setTimeout(120000);
			httpRequest.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:su="http://su_fgetdett_draft_ws.ws.localhost/">'+
								   '<soapenv:Header/>'+
								   '<soapenv:Body>'+
									  '<su:su_fgetdett_draft_ws_Run>'+
										 '<su:m_UserName>' + IntegrationTIC.UserName__c + '</su:m_UserName>'+
										 '<su:m_Password>' + IntegrationTIC.Password__c + '</su:m_Password>'+
										 '<su:p_ElencoBase64>' + base64DocStatus + '</su:p_ElencoBase64>'+
									  '</su:su_fgetdett_draft_ws_Run>'+
								   '</soapenv:Body>'+
								'</soapenv:Envelope>');
			
			httpResponse = httpObject.send(httpRequest);
			if (httpResponse.getStatusCode() == 200) {
				system.debug('Response 200 - ' + httpResponse.getBody());

				XMLSerializer serializer = new XMLSerializer();
				Set<string> Nodi = new Set<string> { 'evasioni' };

				string jsonString = serializer.xmlToJSON(httpResponse.getBody(), Nodi);	
				string Ottimizzato = jsonString.replace('"evasioni":""','"evasioni":"{}"').replace('\\','').replace('"[', '[').replace(']"', ']').replace('\\','').replace('return','returnXYZ').replace('"{"','{"').replace('"}"','"}');
				//string Ottimizzato = jsonString.replace('"evasioni":""','"evasioni":"{}"').replace('\\','').replace('"[', '[').replace(']"', ']').replace('\\','').replace('return','returnXYZ');
				System.debug('Deserialize Ottimizzato --- ' + Ottimizzato.replace('"evasioni":""','"evasioni":null'));
				//viene sostituito evasioni con NULL se il tag non cotiene valori
				TICApi.resStatus = (TICstructure.ResponseStatusTic) JSON.deserialize( Ottimizzato.replace('"evasioni":""','"evasioni":null'), TICstructure.ResponseStatusTic.class);
				System.debug(TICApi.resStatus);

				return true;
			} else {
				system.debug('Response - su_fgetdett_draft_ws <> 200' + httpResponse.getBody());				
				
				string NameLog = 'Get Status From TIC ' + String.valueOf(Datetime.now().format('dd/MM/yyyy'));
				string description = 'La chiamata al servizio per lo stato della fattura ha restituito errore. XML Inviati: ' + XMLToSend + ' Response API: ' + httpResponse.getBody();
				TIC_Custom_Log__c log = CustomLog.log(NameLog,description,'Errore call get status', 'TICApiHelper - GetStatusFromTIC API');
				BatchSincroStatiInvoice.TICLog.add(log);
				
				return false;
			}

		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);			
			System.debug('Qualcosa è andato storto nella chiamata a TIC per la ricezione dello stato. Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber());
			
			string NameLog = 'Get Status From TIC ' + String.valueOf(Datetime.now().format('dd/MM/yyyy'));
			string description = 'Qualcosa è andato storto nella chiamata a TIC per la ricezione dello stato. XML: ' + XMLToSend + ' Messaggio errore: ' + e.getMessage() + ' line: ' + e.getLineNumber();
			TIC_Custom_Log__c log = CustomLog.log(NameLog,description,'Errore call get status', 'TICApiHelper - GetStatusFromTIC');
			BatchSincroStatiInvoice.TICLog.add(log);
			
			return false;
		}
	}

	  /*
	  *	------------------------------------------------------- RETRIEVE STATO FATTURA ------------------------------------------------------------
	  */

}