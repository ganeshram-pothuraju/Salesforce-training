import { LightningElement } from 'lwc';

export default class EligibleJobs extends LightningElement {

    // Job information
    companyName = 'Microsoft';
    jobRole = 'Software Engineer';
    packageOffered = '12 LPA';
    location = 'Hyderabad';
    deadline = '18 August';

    // UI state
    showDetails = false;
    showSuccess = false;

    // View Details button
    handleViewDetails() {

        this.showDetails = true;

    }

    // Apply button
    handleApply() {

        this.showSuccess = true;

    }
}
