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
}
