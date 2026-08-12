public with sharing class NotificationService {
    public static void notifyStatusChange(List<Application__c> apps) {
        for (Application__c app : apps) {
            System.debug('Notify: ' + app.Id + ' is now ' + app.Status__c);
        }
    }
}
