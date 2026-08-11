public with sharing class ApplicationService {

    public static void processApplication(Id applicationId){

        System.enqueueJob(
            new ApplicationPostProcessingJob(applicationId)
        );

    }
}
