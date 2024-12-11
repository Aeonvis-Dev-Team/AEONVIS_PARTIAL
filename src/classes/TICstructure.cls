public class TICstructure {

	public class ResponseTic {
		public Envelope Envelope { get; set; }
	}

	public class ResponseStatusTic {
		public EnvelopeStatus Envelope { get; set; }
	}

	public class Envelope
	{
		public Body Body { get; set; }
	}

	public class EnvelopeStatus
	{
		public BodyStatus Body { get; set; }
	}

	public class Body {
		public su_fimport_draft_ws_RunResponse su_fimport_draft_ws_RunResponse { get; set; }
	}

	public class BodyStatus {
		public su_fgetdett_draft_ws_RunResponse su_fgetdett_draft_ws_RunResponse { get; set; }
	}

	public class su_fimport_draft_ws_RunResponse {
		public List<responseSendTIC> returnXYZ { get; set; }
	}

	public class su_fgetdett_draft_ws_RunResponse {
		public List<responseStatus> returnXYZ { get; set; }
	}

	public class responseSendTIC {
		public string ragsoc { get; set; }
		public string numtic { get; set; }
		public string data { get; set; }
		public Decimal totale { get; set; }
		public string dettaglio { get; set; }
		public string num { get; set; }
	}

	public class responseStatus {
		public string ragsoc { get; set; }
		public string numtic { get; set; }
		public string tipdoc { get; set; }
		public string data { get; set; }
		public Decimal totale { get; set; }
		public List<dettaglioStatus> dettaglio { get; set; }
		public Evasioni evasioni { get; set; }
	}

	public class dettaglioStatus {
		public string stato { get; set; }
		public string tipdoc { get; set; }
		public string data { get; set; }
	}

	public class Evasioni {
		public string numtic { get; set; }
		public string stato { get; set; }
		public string tipdoc { get; set; }
		public string data { get; set; }
		public string dataori { get; set; }
		public string numticori { get; set; }
		public string tipdocori { get; set; }
	}

	public class Doc {
		public Documenti Documenti { get; set; }
	}

	public class Documenti {
		public List<Documento> documento { get; set; }
	}

	public class Documento {
		public string partitaivatic { get; set; }
		public string tipodocumento { get; set; }
		public string numero { get; set; }
		public string serie { get; set; }
		public string data { get; set; }
		public string forgiu { get; set; }
		public string ragionesociale { get; set; }
		public string cognome { get; set; }
		public string nome { get; set; }
		public string idpaese { get; set; }
		public string idcodice { get; set; }
		public string codicefiscale { get; set; }
		public string coddestinatario { get; set; }
		public string pecdestinatario { get; set; }
		public string indirizzo { get; set; }
		public string numerocivico { get; set; }
		public string cap { get; set; }
		public string comune { get; set; }
		public string provincia { get; set; }
		public string nazione { get; set; }
		public string telefono { get; set; }
		public string email { get; set; }
		public string stato { get; set; }
		public string SDI { get; set; }
		public string addebitaBollo { get; set; }
		public decimal Bollo { get; set; }
		public string IvaBollo { get; set; }
		public decimal prezzoLordo { get; set; }
		public scadenzeContenitore scadenze { get; set; }
		public righeContenitore righe { get; set; }
	}

	public class StatusDoc {
		public StatusDocumenti Documenti { get; set; }
	}

	public class StatusDocumenti {
		public List<StatusDocumento> documento { get; set; }
	}

	public class StatusDocumento {
		public string tipodocumento { get; set; }
		public string numtic { get; set; }
		public string data { get; set; }
		public string ragionesociale { get; set; }
	}

	public class scadenza {
		public string dataScadenza { get; set; }
		public Decimal importoRata { get; set; }
		public string tipoPagamento { get; set; }
	}

	public class righeContenitore {
		public List<riga> riga { get; set; }
	}

	public class scadenzeContenitore {
		public List<scadenza> scadenza { get; set; }
	}

	public class riga {
		public Integer numeroriga { get; set; }
		public string codicearticolo { get; set; }
		public string descrizioneart { get; set; }
		public string descrizioneartsupp { get; set; }
		public string codiva { get; set; }
		public string unimis { get; set; }
		public string quantita { get; set; }
		public string prezzo { get; set; }
	}

}