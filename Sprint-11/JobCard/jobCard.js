import { LightningElement, api } from 'lwc';

export default class JobCard extends LightningElement {
    @api job;

    handleViewDetails() {
        this.dispatchEvent(
            new CustomEvent('viewdetails', {
                detail: { jobId: this.job.Id }
            })
        );
    }

    handleApply() {
        this.dispatchEvent(
            new CustomEvent('apply', {
                detail: { jobId: this.job.Id }
            })
        );
    }
}
