public with sharing class ApplicationScheduler
implements Schedulable{

    public void execute(SchedulableContext context){

        Database.executeBatch(
            new ApplicationBatch(),
            200
        );
    }
}
