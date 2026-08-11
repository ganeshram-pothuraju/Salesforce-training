public with sharing class PlacementController {

    @AuraEnabled
    public static Id applyForJob(Id studentId, Id jobId) {

        List<Application__c> existing = [
            SELECT Id
            FROM Application__c
            WHERE Student__c = :studentId
            AND Job__c = :jobId
            LIMIT 1
        ];

        if (!existing.isEmpty()) {
            throw new AuraHandledException(
                'You have already applied for this job.'
            );
        }

        Application__c application = new Application__c(
            Student__c = studentId,
            Job__c = jobId,
            Status__c = 'Applied'
        );

        insert application;

        return application.Id;
    }
}
