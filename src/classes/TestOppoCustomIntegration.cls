@isTest
public class TestOppoCustomIntegration {

	@isTest
	private static void CreateOpportunityToCloseWon() {

		List<account> Acc = DataFactory.createAccount(1, 'Luca');
		account AccPartners = DataFactory.createAccountPartners('Luca Pa');
		DataFactory.createImTriggerOpportunity();

		System.debug(Acc);


		Opportunity NewOppo = new Opportunity();

		NewOppo.Name = 'Test Oppo';
		NewOppo.StageName = 'Closed Won';
		NewOppo.Open_date__c = Date.today();
		NewOppo.CloseDate = Date.today().addDays(1);
		NewOppo.Line_of_Business__c = 'CRM';
		NewOppo.Partner__c = AccPartners.Id;
		NewOppo.Platform__c = 'Salesforce';
		NewOppo.Amount = 21000;
		NewOppo.Revenue__c = 10;
		NewOppo.Elapsed__c = 12;
		NewOppo.T_L__c = 'Not included - out of pocket';
		NewOppo.LeadSource = 'Salesforce event';
		NewOppo.Order_Date__c = Date.today();
		NewOppo.Order_Number__c = '123';
		NewOppo.Order_Amount__c = 21000;
		NewOppo.Contract_type__c = 'Consulting';
		NewOppo.Engagement_Type__c = 'T&M';
		//NewOppo.Billin_Plan_Status__c = 'Not Completed';
		NewOppo.Bill_to__c = Acc[0].Id;
		NewOppo.TR_Project_ID__c = 'A';
		NewOppo.Quality_review_status__c = 'Not Relevant';
		NewOppo.Residual_Capacity_Created__c = false;
		NewOppo.SUB_LOB__c = 'CRM';
		NewOppo.Offering__c = 'CRM';

		test.startTest();

		insert NewOppo;

		test.stopTest();
	}

	@isTest
	private static void UpdateOpportunityToCloseWon() {

		List<account> Acc = DataFactory.createAccount(1, 'Luca');
		account AccPartners = DataFactory.createAccountPartners('Luca Partners');


		System.debug(Acc);


		Opportunity NewOppo = new Opportunity();

		NewOppo.Name = 'Test Oppo';
		NewOppo.StageName = 'Negotiation';
		NewOppo.Open_date__c = Date.today();
		NewOppo.CloseDate = Date.today().addDays(1);
		NewOppo.Line_of_Business__c = 'CRM';
		NewOppo.Partner__c = AccPartners.Id;
		NewOppo.Platform__c = 'Salesforce';
		NewOppo.Amount = 21000;
		NewOppo.Revenue__c = 100;
		NewOppo.Elapsed__c = 12;
		NewOppo.T_L__c = 'Not included - out of pocket';
		NewOppo.LeadSource = 'Salesforce event';
		NewOppo.Order_Date__c = Date.today();

		NewOppo.Contract_type__c = 'Consulting';
		NewOppo.Engagement_Type__c = 'T&M';
		//NewOppo.Billin_Plan_Status__c = 'Not Completed';
		NewOppo.Bill_to__c = Acc[0].Id;
		NewOppo.TR_Project_ID__c = 'TES_001';
		NewOppo.Quality_review_status__c = 'Not Relevant';
		NewOppo.SUB_LOB__c = 'CRM';
		NewOppo.Offering__c = 'CRM';

		insert NewOppo;

		test.startTest();
		DataFactory.createImTriggerOpportunity();

		NewOppo.Order_Number__c = '123';
		NewOppo.Elapsed__c = 12;
		NewOppo.Engagement_Type__c = 'T&M';
		NewOppo.Order_Amount__c = 21000;
		NewOppo.StageName = 'Closed Won';
		NewOppo.TR_Project_ID__c = '456';

		update NewOppo;

		test.stopTest();
	}

}