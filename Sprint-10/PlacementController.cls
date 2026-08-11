public with sharing class PlacementController {

    @AuraEnabled(cacheable=true)
    public static List<Job__c> getEligibleJobs(Id studentId) {

        return PlacementService.getEligibleJobs(studentId);
    }

    @AuraEnabled
    public static Id applyForJob(Id studentId, Id jobId) {

        return PlacementService.submitApplication(studentId, jobId);
    }
}
