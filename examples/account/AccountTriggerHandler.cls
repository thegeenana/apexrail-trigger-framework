public inherited sharing class AccountTriggerHandler extends ApexRailHandler {
    protected override void beforeInsert() {
        runNameNormalisation();
    }

    protected override void beforeUpdate() {
        runNameNormalisation();
    }

    private void runNameNormalisation() {
        ApexRailPipeline.execute(
            new List<ApexRailAction>{new AccountNameNormalisationAction()},
            context
        );
    }

    protected override void runAfter() {
        // This example declares only before contexts, so there is no work to flush.
    }
}
