public class OpenApiStructure {

	public class openApiLoginResponse {
		public string token { get; set; }
		//public Boolean success { get; set; }
		//public string message { get; set; }
		//public string error { get; set; }
	}

	public class ResponseCompanyInfo {
		public List<data> data { get; set; }
	}

	public class data {

		public string taxCode { get; set; }
		public string vatCode { get; set; }
		public string companyName { get; set; }
		public address address { get; set; }
		//public string activityStatus { get; set; }
		public string sdiCode { get; set; }
		public string pec { get; set; }
	}

	public class address {
		public registeredOffice registeredOffice { get; set; } }

	public class registeredOffice {
		//public string toponym { get; set; }
		//public string street { get; set; }
		//public string streetNumber { get; set; }
		public string streetName { get; set; }
		public string town { get; set; }
		//public string hamlet { get; set; }
		public string province { get; set; }
		public string zipCode { get; set; }
	}

	public class provinciaResponse {
		public dataPR data { get; set; }
		//public Boolean success { get; set; }
		//public string message { get; set; }
		//public string error { get; set; }
	}

	public class dataPR {
		public string provincia { get; set; }
	}
}