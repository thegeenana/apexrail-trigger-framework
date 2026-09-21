public inherited sharing class OpportunityTriggerHandler
    extends ApexRailHandler {

    private static final String CLOSED_WON_TASK_WORK =
        'Opportunity.ClosedWonTask';

    protected override void afterInsert() {
        collectClosedWonTasks(
            (List<Opportunity>) context.newRecords,
            null
        );
    }

    protected override void afterUpdate() {
        collectClosedWonTasks(
            (List<Opportunity>) context.newRecords,
            (Map<Id, Opportunity>) context.oldMap
        );
    }

    private void collectClosedWonTasks(
        List<Opportunity> currentRecords,
        Map<Id, Opportunity> previousRecords
    ) {
        for (Opportunity currentRecord : currentRecords) {
            Opportunity previousRecord = previousRecords == null
                ? null
                : previousRecords.get(currentRecord.Id);

            Boolean isNowClosedWon = currentRecord.StageName == 'Closed Won';
            Boolean wasPreviouslyClosedWon = previousRecord != null &&
                previousRecord.StageName == 'Closed Won';

            if (isNowClosedWon && !wasPreviouslyClosedWon) {
                Task followUpTask = new Task(
                    WhatId = currentRecord.Id,
                    OwnerId = currentRecord.OwnerId,
                    Subject = 'Prepare Closed Won handover',
                    Status = 'Not Started',
                    Priority = 'Normal',
                    ActivityDate = Date.today().addDays(1)
                );

                ApexRailAfterBuffer.register(
                    CLOSED_WON_TASK_WORK,
                    String.valueOf(currentRecord.Id),
                    followUpTask
                );
            }
        }
    }

    protected override void runAfter() {
        List<SObject> bufferedRecords =
            ApexRailAfterBuffer.drain(CLOSED_WON_TASK_WORK);

        if (bufferedRecords.isEmpty()) {
            return;
        }

        List<Task> tasksToInsert = new List<Task>();
        for (SObject bufferedRecord : bufferedRecords) {
            tasksToInsert.add((Task) bufferedRecord);
        }

        insert tasksToInsert;
    }
}
