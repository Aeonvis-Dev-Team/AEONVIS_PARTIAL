public class TICApi {

	public static string gblReturnMessage = '';
	public static String base64DocToSend = '';
	public static String base64DocStatus = '';
	public static TICstructure.ResponseTic res = new TICstructure.ResponseTic();
	public static TICstructure.ResponseStatusTic resStatus = new TICstructure.ResponseStatusTic();

	/**
	 * @description: Invia la fattura e righe (billing items) al sistema TIC. metodo richiamato da un flusso->avrà sempre 1 id Account nella lista di input 
	 * @param mtdAccountId: lista id dei billing items retrieve
	 */
	@InvocableMethod(label = 'Send Invoice To TIC' description = 'Invio della fattura a TIC' Callout = true)
	public static List<String> sendInvoiceTIC(List<Id> mtdBillingItemId) {

		try {
			System.debug('Billing Item ID da inviare ---> ' + mtdBillingItemId);

			//retrieve dell'account, opportunita e billing items
			List<Billing_Item__c> WorkBI = TICApiHelper.retrieveData(mtdBillingItemId);

			Boolean XML = false;
			//generazione xml e decodifica
			if (WorkBI != null) { XML = TICApiHelper.generaXML(WorkBI); }

			if (XML == true) {
				//invio della bozza a TIC
				Boolean EsitoInvio = TICApiHelper.SendToTIC();
				if (EsitoInvio == true)
				{
					//aggiornamento del numero bozza ricevuto da TIC
					string NrBozzaTic = res.Envelope.Body.su_fimport_draft_ws_RunResponse.returnXYZ[0].numtic;
					System.debug('NrBozzaTic --> ' + NrBozzaTic);
					//controllo se contiene messaggio OK --> aggiorno stato billing
					System.debug(String.valueOf(res.Envelope.Body.su_fimport_draft_ws_RunResponse.returnXYZ[0].dettaglio));
					if (String.valueOf(res.Envelope.Body.su_fimport_draft_ws_RunResponse.returnXYZ[0].dettaglio).contains('OK') == true)
					{

						System.debug('Messaggio OK --> ' + String.valueOf(res.Envelope.Body.su_fimport_draft_ws_RunResponse.returnXYZ[0].dettaglio));

						List<Billing_Item__c> ListBi = new List<Billing_Item__c> ();

						for (Billing_Item__c BI : WorkBI)
						{
							System.debug('NrBozzaTic --- ' + NrBozzaTic);
							BI.TIC_draft_no__c = NrBozzaTic;
							BI.Inviata_a_TIC__c = true;
							//BI.Billing_status__c = 'Invoice in progress';
							BI.Tic_Invoice_Created_Date__c = Datetime.now();

							ListBi.add(BI);
							//Database.SaveResult[] srList = Database.update(WorkBI, false);
							//System.debug('srList --- ' + srList);
							//update WorkBI;
						}

						update ListBi;
					}


					//aggiornamento dei billing items con nr bozza ricevuto da tic
					//update WorkBI;
					gblReturnMessage += '\n' + '\n' + 'Nr. Bozza TIC: ' + NrBozzaTic;
				}
			}

			System.debug('gblReturnMessage  ----  ' + gblReturnMessage);
			return new List<String> { gblReturnMessage };

		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);
			gblReturnMessage = 'Qualcosa è andato storto (catch). Messaggio errore ' + e.getMessage() + '\n' + 'Line: ' + e.getLineNumber();
			return new List<String> { gblReturnMessage };
		}
	}

	/*
	 * Generazione XML da inviare per lo stato e aggiornamento stato di tutti i billing padre e figli
	 */
	public static Boolean retrieveStatusInvoice(List<Billing_Item__c> WorkBI) {

		try {

			Boolean EsitoStato = false;
			string XML = null;
			//generazione xml e decodifica

			//generazione XML da passare a zucchetti per retrieve dello stato
			if (WorkBI != null) { XML = TICApiHelper.generaXMLRetrieveStatus(WorkBI); }

			//se esito generazione XML è andata bene chiamo il servizio
			if (XML != null)
			{
				EsitoStato = TICApiHelper.GetStatusFromTIC(XML);
				System.debug('Esito stato ---> ' + EsitoStato);
			}

			//se chiamata al servizio di ricezione stato è andata bene
			if (EsitoStato == true)
			{

				System.debug('WorkBI[0].TIC_draft_no__c --- ' + WorkBI[0].TIC_draft_no__c);

				//se abbiamo solo numero bozza valorizziamo il numero della fattura per usarlo poi per la retrieve dello stato
				if (String.isNotBlank(WorkBI[0].TIC_draft_no__c) == true && String.isNotBlank(WorkBI[0].TIC_invoice_no__c) == false) {

					//controllo se evasioni è presente come tag, se nullo salto aggiornamento num fatt definitivo
					TICstructure.Evasioni Evasioni = resStatus.Envelope.Body.su_fgetdett_draft_ws_RunResponse.returnXYZ[0].evasioni;
					System.debug('Evasioni --->' + Evasioni);
					if (Evasioni != null)
					{
						System.debug('Evasioni --->' + Evasioni);
						TICstructure.Evasioni EVA = Evasioni;
						System.debug('EVA --->' + EVA);
						//aggiornamento del numero bozza ricevuto da TIC
						string NrFattTic = EVA.numtic;
						string StatoTic = EVA.stato;
						id IDBilling = WorkBI[0].Id;
						List<Billing_Item__c> GetBI = [SELECT Id, Name, Tecnical_Status__c, Invoice_status__c, Account__r.Company_name__c, TIC_invoice_no__c, TIC_draft_no__c FROM Billing_Item__c WHERE id = :IDBilling or Bill_with__c = :IDBilling];

						List<TICstructure.dettaglioStatus> dettaglioStatus = resStatus.Envelope.Body.su_fgetdett_draft_ws_RunResponse.returnXYZ[0].dettaglio;

						string StatoTicDett = (dettaglioStatus[0] != null) ? dettaglioStatus[0].stato : null;

						//per tutti i billing item padri e figlio aggiorno il numero di fattura
						for (Billing_Item__c BIUpdt : GetBI)
						{
							if (StatoTic.toUpperCase() == 'CO' || StatoTicDett.toUpperCase() == 'CONSEGNATO') {
								BIUpdt.Last_update_by_TIC__c = String.valueOf(System.Datetime.now());
								BIUpdt.TIC_invoice_no__c = NrFattTic;
								BIUpdt.Billing_number__c = NrFattTic;
								BIUpdt.Invoice_status__c = StatoTic;
								BIUpdt.Tecnical_Status__c = true;
								BIUpdt.Billing_status__c = 'Invoiced';
							}
						}
						//aggiornamento dei billing items con nr bozza ricevuto da tic
						update GetBI;

						for (Billing_Item__c BIUpdt : GetBI)
						{
							BIUpdt.Tecnical_Status__c = false;
						}
						update GetBI;
					}
				}

			} else
			{
				return false;
			}

			return true;

		} catch(Exception e) {
			//GestioneLog.InsertCatchLog(e);
			gblReturnMessage = 'Qualcosa è andato storto (catch). Messaggio errore ' + e.getMessage() + '\n' + 'Line: ' + e.getLineNumber();

			string NameLog = 'Get Status ' + String.valueOf(Datetime.now().format('dd/MM/yyyy'));
			string Billing = WorkBI[0].Name + ' - ' + WorkBI[0].Opportunity__r.Name;
			string description = 'Qualcosa è andato storto (catch) per il billing items ' + Billing + ' . Messaggio errore ' + e.getMessage() + '\n' + 'Line: ' + e.getLineNumber();
			TIC_Custom_Log__c log = CustomLog.log(NameLog, description, 'Errore ricezione stato', 'TICApi - retrieveStatusInvoice');
			BatchSincroStatiInvoice.TICLog.add(log);

			return false;
		}
	}
}