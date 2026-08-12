trigger ApplicationTrigger on Application__c (before insert, after update) {

    if (Trigger.isBefore && Trigger.isInsert) {
        ApplicationService.validateApplications(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        StatisticsService.updatePlacementStatistics(Trigger.new);

        List<Application__c> toNotify = new List<Application__c>();
        for (Application__c app : Trigger.new) {
            Application__c oldApp = Trigger.oldMap.get(app.Id);
            if (app.Status__c != oldApp.Status__c) {
                toNotify.add(app);
            }
        }
        if (!toNotify.isEmpty()) {
            NotificationService.notifyStatusChange(toNotify);
        }
    }
}
