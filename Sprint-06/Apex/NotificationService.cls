public class NotificationService {

public static void sendNotifications(List<Application__c> newApplications,
                                      Map<Id,Application__c> oldMap)
{
    for(Application__c app:newApplications){
        Application__c oldApp=oldMap.get(app.Id);
        if(oldApp.Status__c!=app.Status__c){
            System.debug(LoggingLevel.ERROR,
    '***** NOTIFICATION SERVICE EXECUTED ***** ' +
    'Student Application ' + app.Id +
    ' changed from ' +
    oldApp.Status__c +
    ' to ' +
    app.Status__c
);
        }
    }  
}
}
