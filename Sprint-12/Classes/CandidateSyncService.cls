public class CandidateSyncService {

    public static void processSelectedApplications(
        List<Application__c> newApplications,
        Map<Id, Application__c> oldMap
    ) {

        for (Application__c application : newApplications) {

            Application__c oldApplication =
                oldMap.get(application.Id);

            // Check whether status changed to Selected
            if (
                application.Status__c == 'Selected' &&
                oldApplication.Status__c != 'Selected'
            ) {

                // Prevent duplicate submission
                if (application.Integration_Status__c != 'Sent') {

                    // Mark as pending
                    application.Integration_Status__c = 'Pending';

                    // Enqueue background job
                    System.enqueueJob(
                        new CandidateSyncQueueable(
                            application.Id
                        )
                    );
                }
            }
        }
    }
}
