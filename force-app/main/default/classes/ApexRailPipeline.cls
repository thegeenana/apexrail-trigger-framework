public inherited sharing class ApexRailPipeline {
    private ApexRailPipeline() {}

    public static void execute(
        List<ApexRailAction> actions,
        ApexRailContext context
    ) {
        if (actions == null || actions.isEmpty()) {
            return;
        }
        if (context == null) {
            throw new ApexRailException('ApexRail pipeline requires a context.');
        }

        for (ApexRailAction action : actions) {
            if (action == null) {
                throw new ApexRailException(
                    'ApexRail pipelines cannot contain a null action.'
                );
            }
            action.execute(context);
        }
    }
}
