public with sharing class PlacementApplicationService {
    
    public static Student__c getStudent(Id studentId){
        Student__c student =
         [SELECT Id,Name,CGPA__C,Branch__c,Backlogs__c
        FROM Student__c
        WHERE Id=:studentId
        LIMIT 1
        ];
        return student;
    }
    
    public static Job__c getJob(Id jobId) {
	Job__c job = [
        SELECT Id,
               Name,
               Minimum_CGPA__c,
               Eligible_Branch__c,
               Maximum_Backlogs__c,
               Application_Deadline__c
        FROM Job__c
        WHERE Id = :jobId
        LIMIT 1
    ];

    return job;
}
    public static Boolean checkDuplicate(Id studentId, Id jobId) {

    List<Application__c> applications = [
        SELECT Id
        FROM Application__c
        WHERE Student__c = :studentId
        AND Job__c = :jobId
    ];

    return !applications.isEmpty();
}
    public static Boolean validateEligibility(Student__c student,
                                          Job__c job) {

    if(student.CGPA__c < job.Minimum_CGPA__c)
        return false;

    if(student.Branch__c != job.Eligible_Branch__c)
        return false;

    if(student.Backlogs__c > job.Maximum_Backlogs__c)
        return false;

    if(Date.today() > job.Application_Deadline__c)
        return false;

    return true;
}
    public static void createApplication(Id studentId, Id jobId) {

    Application__c application = new Application__c();

    application.Student__c = studentId;
    application.Job__c = jobId;
    application.Status__c = 'Applied';

    insert application;
}
    public static void updateApplicationStatus(Id applicationId,
                                           String status) {

    Application__c application = [
        SELECT Id,
               Status__c
        FROM Application__c
        WHERE Id = :applicationId
        LIMIT 1
    ];

    application.Status__c = status;

    update application;
}
}
