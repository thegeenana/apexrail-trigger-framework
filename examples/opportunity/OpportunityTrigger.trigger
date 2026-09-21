trigger OpportunityTrigger on Opportunity (after insert, after update) {
    ApexRail.dispatch(new OpportunityTriggerHandler());
}
