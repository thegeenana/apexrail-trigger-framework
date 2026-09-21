@IsTest
private class OpportunityTriggerHandlerTest {
    @IsTest
    static void closingOpportunitiesCreatesOneTaskPerOpportunity() {
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer indexValue = 0; indexValue < 200; indexValue++) {
            opportunities.add(new Opportunity(
                Name = 'ApexRail Opportunity ' + indexValue,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ));
        }
        insert opportunities;

        for (Opportunity opportunity : opportunities) {
            opportunity.StageName = 'Closed Won';
        }

        Test.startTest();
        update opportunities;
        Test.stopTest();

        Set<Id> opportunityIds = new Map<Id, Opportunity>(
            opportunities
        ).keySet();

        List<Task> createdTasks = [
            SELECT Id, WhatId, Subject
            FROM Task
            WHERE WhatId IN :opportunityIds
            AND Subject = 'Prepare Closed Won handover'
        ];

        Assert.areEqual(200, createdTasks.size());
    }

    @IsTest
    static void unrelatedUpdateDoesNotCreateAnotherTask() {
        Opportunity opportunity = new Opportunity(
            Name = 'Already Won',
            StageName = 'Closed Won',
            CloseDate = Date.today()
        );
        insert opportunity;

        opportunity.Description = 'Unrelated change';
        update opportunity;

        List<Task> createdTasks = [
            SELECT Id
            FROM Task
            WHERE WhatId = :opportunity.Id
            AND Subject = 'Prepare Closed Won handover'
        ];

        Assert.areEqual(1, createdTasks.size());
    }
}
