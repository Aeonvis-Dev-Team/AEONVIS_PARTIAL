import { LightningElement, wire, api } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { NavigationMixin } from "lightning/navigation";
import StageName from "@salesforce/schema/Opportunity.StageName";
import SDI_inserito__c from "@salesforce/schema/Opportunity.SDI_inserito__c";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ThrowToastMessage extends NavigationMixin(LightningElement) {

	@api recordId;
	error;
	openPackageOnBo;

	@wire(getRecord, {
		recordId: "$recordId",
		fields: [StageName, SDI_inserito__c],
	})

	handleOpportunityData(wireResult){
		const { error, data } = wireResult;

		if (data){
			const Stage = getFieldValue(data, StageName);
			const hasSDI = !!getFieldValue(data, SDI_inserito__c);

			if (Stage === 'Closed Won' && hasSDI === false){
				this.showWarningToast()
			}
		}
	
	}
	


	//Questo metodo va richiamato ad un certo punto nel codice che andrà scritto sopra in questa classe per poi lanciare il messaggio di warning
	showWarningToast() {
		const evt = new ShowToastEvent({
			title: 'Warning',
			message: 'Aggiornare il codice SDI nelle billing info della scheda account﻿',
			variant: 'warning',
			mode: 'dismissable'
		});
	this.dispatchEvent(evt);
	}

}