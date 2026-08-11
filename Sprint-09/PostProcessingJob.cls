public with sharing class ApplicationPostProcessingJob implements Queueable {

    private Id applicationId;

    public ApplicationPostProcessingJob(Id applicationId){
        this.applicationId = applicationId;
    }

    public void execute(QueueableContext context){

        Application__c app = [
            SELECT Id, Name, Status__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        System.debug('Processing Application: ' + app.Name);

        System.enqueueJob(
            new PlacementNotificationJob(applicationId)
        );
    }
}
