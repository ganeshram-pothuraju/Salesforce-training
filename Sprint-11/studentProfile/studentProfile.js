import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class StudentProfile extends LightningElement {

    @api recordId;

    handleSuccess(event) {

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Profile updated successfully',
                variant: 'success'
            })
        );

        this.dispatchEvent(
            new CustomEvent('profilesaved', {
                detail: {
                    studentId: event.detail.id
                }
            })
        );
    }

    handleError(event) {

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: event.detail.message,
                variant: 'error'
            })
        );
    }
}
