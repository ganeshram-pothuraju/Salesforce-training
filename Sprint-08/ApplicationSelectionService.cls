public class ApplicationService {

    public static void updateSelectedStudents(
        List<Application__c> newApplications,
        Map<Id, Application__c> oldMap
    ) {

        List<Student__c> studentsToUpdate = new List<Student__c>();

        for (Application__c app : newApplications) {

            Application__c oldApp = oldMap.get(app.Id);

            if (oldApp.Status__c != 'Selected' &&
                app.Status__c == 'Selected') {

                Student__c student = new Student__c(
                    Id = app.Student__c,
                    Placement_Status__c = 'Placed',
                    Selected_Company__c = app.Job__c
                );

                studentsToUpdate.add(student);
            }
        }

        if (!studentsToUpdate.isEmpty()) {
            update studentsToUpdate;
        }
    }
}

/* Trigger */

trigger ApplicationTrigger on Application__c (after update) {

    ApplicationService.updateSelectedStudents(
        Trigger.new,
        Trigger.oldMap
    );

}
