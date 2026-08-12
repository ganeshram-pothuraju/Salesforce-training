trigger ApplicationTrigger on Application__c (after update) {
    
    if(trigger.isBefore && trigger.isAfter){
        
        StatisticsService.updatePlacementStatistics(Trigger.new);
    }
}
