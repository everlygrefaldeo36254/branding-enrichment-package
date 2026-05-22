import { LightningElement, api, wire, track } from 'lwc';

import enrichBranding from '@salesforce/apex/BrandingController.enrichBranding';
import getAccount from '@salesforce/apex/BrandingController.getAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex }from '@salesforce/apex';
export default class BrandingPanel extends LightningElement {

    @api recordId;

    @track isLoading = false;

    wiredAccountResult;

    logoUrl;
    brandingStatus;

    @wire(getAccount, { recordId: '$recordId' })
    wiredAccount(result) {

        this.wiredAccountResult = result;

        if(result.data) {
            console.log('full data:', JSON.stringify(result.data));

            this.logoUrl =
                result.data.acctbrand__Brand_Logo_URL__c;

            this.brandingStatus =
                result.data.acctbrand__Branding_Status__c;
            
            console.log('this.logoUrl:', this.logoUrl);
            console.log('this.brandingStatus:', this.brandingStatus);
        }
    }

    async handleEnrich() {

        this.isLoading = true;

        try {

            await enrichBranding({
                recordId: this.recordId
            });

            this.showToast(
                'Success',
                'Branding enrichment started.',
                'success'
            );
            console.log('recordId:', this.recordId);
            setTimeout(async () => {
                await refreshApex(
                    this.wiredAccountResult
                );

                this.isLoading = false;
            }, 3000);

        } catch(error) {

            this.isLoading = false;

            this.showToast(
                'Error',
                error.body.message,
                'error'
            );
        }
    }

    showToast(title, message, variant) {

        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}