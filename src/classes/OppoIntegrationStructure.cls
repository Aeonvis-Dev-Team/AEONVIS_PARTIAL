public class OppoIntegrationStructure {
	public class LoginAPResponse {
		public String access_token { get; set; }
		public String instance_url { get; set; }
	}

	//public class RetrieveOpportunity {
	//public Integer totalSize { get; set; }
	//public Boolean done { get; set; }
	//public List<records> records { get; set; }
	//}

	public class records {
		public string Id { get; set; }
		public string Name { get; set; }
		public Date CloseDate { get; set; }
		public Account Account { get; set; }
		public Decimal Amount { get; set; }
		public Decimal Ammontare_ArrotondatoXYZ { get; set; }
		public Decimal MargineXYZ { get; set; }
		public Decimal Expected_MarginXYZ { get; set; }
		public string Line_of_BusinessXYZ { get; set; }
		public string CodeXYZ { get; set; }
		public string Contract_typeXYZ { get; set; }
		public string Engagement_TypeXYZ { get; set; }
	}

	public class Account {
		public string Id { get; set; }
		public string Name { get; set; }
		public string Codice_SDIXYZ { get; set; }
		public BillingAddress BillingAddress { get; set; }
		public ShippingAddress ShippingAddress { get; set; }
	}

	public class BillingAddress {
		public string city { get; set; }
		public string country { get; set; }
		public string postalCode { get; set; }
		public string state { get; set; }
		public string street { get; set; }
	}

	public class ShippingAddress {
		public string city { get; set; }
		public string country { get; set; }
		public string postalCode { get; set; }
		public string state { get; set; }
		public string street { get; set; }
	}
}