trigger ApplicationTrigger on Application__c (before insert, after update) {

    if (Trigger.isBefore && Trigger.isInsert) {
        PlacementApplicationService.validateApplications(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {

        // Existing functionality
        StatisticsService.updatePlacementStatistics(
            Trigger.new,
            Trigger.oldMap
        );

        NotificationService.sendNotifications(
            Trigger.new,
            Trigger.oldMap
        );

        // Sprint 11 integration
        CandidateSyncService.processSelectedApplications(
            Trigger.new,
            Trigger.oldMap
        );
    }
}
