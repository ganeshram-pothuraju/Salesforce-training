public with sharing class ApplicationService {
    public static void validateApplications(List<Application__c> newApps) {
        for (Application__c app : newApps) {

            if (app.Student__c == null) {
                app.addError('Application must be linked to a Student.');
            }

            if (app.Job__c == null) {
                app.addError('Application must be linked to a Job.');
            }

            if (app.Status__c == null) {
                app.addError('Please select a Status for this application.');
            }

            if (app.Status__c == 'Selected') {
                app.addError('A new application cannot start with Status = Selected.');
            }
        }
    }
}
