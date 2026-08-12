public with sharing class StatisticsService {

    public static void updatePlacementStatistics(List<Application__c> applications) {
        
        Integer totalSelected = [
            select COUNT()
            from Application__c
            where Status__c = 'Selected'
        ];

        System.debug('totalSelected=' +totalSelected);

    }

}
