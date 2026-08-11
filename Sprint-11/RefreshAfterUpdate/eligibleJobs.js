import { LightningElement, api, wire } from 'lwc';
import getEligibleJobs from '@salesforce/apex/PlacementController.getEligibleJobs';
import { refreshApex } from '@salesforce/apex';

export default class EligibleJobs extends LightningElement {

    @api studentId;
    wiredJobs;

    @wire(getEligibleJobs, { studentId: '$studentId' })
    jobs(result) {
        this.wiredJobs = result;
    }

    @api
    refreshJobs() {
        refreshApex(this.wiredJobs);
    }
}
