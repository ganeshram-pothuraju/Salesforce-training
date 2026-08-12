public class StatisticsService {
    public static void updatePlacementStatistics(
        List<Application__c> newApplications,Map<Id,Application__c> oldMap){
            Boolean updateStatistics=false;
            for(Application__c app : newApplications){
                Application__c oldApp=oldMap.get(app.Id);
                if(oldApp.status__c!='selected' && app.status__c=='Selected'){
                    updateStatistics=true;
                    break;
                }
            }
            if(updateStatistics){
                Integer selectedCount =[SELECT COUNT()
                                       FROM Application__c
                                       WHERE status__c='Selected'];
                Placement_Statistic__c stats=[SELECT Id,Total_Selected_Students__c
                                              FROM Placement_Statistic__C
                                              LIMIT 1];
                stats.Total_Selected_Students__c=selectedCount;
                update stats;
            }
        }
    
}
