import { LightningElement, api } from "lwc";
import { CloseActionScreenEvent } from 'lightning/actions';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getStatValue from '@salesforce/apex/StatActionController.getStatValue';
import updateStatValue from '@salesforce/apex/StatActionController.updateStatValue';

export default class StatAction extends LightningElement {
	_recordId;
    stat;

    isLoading = false;

    updateStatValue() {
        updateStatValue({ oppId: this.recordId, statVal: this.stat})
        .then((result) => {
           console.log('Stat Updated');
           updateRecord({ fields: { Id: this.recordId }});
           this.closeQuickAction();
        }).catch((err) => {
            this.closeQuickAction();
            this.showToast('Error', err.body.message, 'error');
            console.log(err.body.message);
        });
    }
    
    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    @api set recordId(value) {
        this._recordId = value;

        getStatValue({ oppId: this.recordId })
        .then((result) => {
            this.isLoading = true;
            console.log('Data', result);
            this.stat = result.isStat__c;
            if (this.stat) {
                this.stat = false;
            } else {
                this.stat = true;
            }
            this.updateStatValue()
        }).catch((err) => {
            this.isLoading = false;
            this.closeQuickAction();
            this.showToast('Error', err.body.message, 'error');
            console.log(err.body.message);
        });
    }

    get recordId() {
        return this._recordId;
    }

    showToast(title, msg, variant, mode = 'dismissible') {
        const event = new ShowToastEvent({
            title: title,
            message: msg,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(event);
    }
}