@IsTest
private class ApexRailHandlerTest {
    private class RecordingHandler extends ApexRailHandler {
        private static Integer beforeUpdateCalls = 0;
        private static Integer afterInsertCalls = 0;
        private static Integer afterUpdateCalls = 0;
        private static Integer runAfterCalls = 0;

        RecordingHandler(ApexRailContext context) {
            super(context);
        }

        protected override void beforeUpdate() {
            beforeUpdateCalls++;
        }

        protected override void afterInsert() {
            afterInsertCalls++;
        }

        protected override void afterUpdate() {
            afterUpdateCalls++;
        }

        protected override void runAfter() {
            runAfterCalls++;
        }

        protected override String getHandlerName() {
            return 'RecordingHandler';
        }
    }

    @IsTest
    static void beforeOperationRunsOnEveryInvocation() {
        resetState();
        ApexRailContext context = contextFor(System.TriggerOperation.BEFORE_UPDATE);

        new RecordingHandler(context).run();
        new RecordingHandler(context).run();

        Assert.areEqual(2, RecordingHandler.beforeUpdateCalls);
    }

    @IsTest
    static void afterOperationAndFinaliserRunForEachInvocation() {
        resetState();
        ApexRailContext context = contextFor(System.TriggerOperation.AFTER_UPDATE);

        new RecordingHandler(context).run();
        new RecordingHandler(context).run();

        Assert.areEqual(2, RecordingHandler.afterUpdateCalls);
        Assert.areEqual(2, RecordingHandler.runAfterCalls);
    }

    @IsTest
    static void distinctAfterOperationsCanEachRunOnce() {
        resetState();

        new RecordingHandler(
            contextFor(System.TriggerOperation.AFTER_INSERT)
        ).run();
        new RecordingHandler(
            contextFor(System.TriggerOperation.AFTER_UPDATE)
        ).run();

        Assert.areEqual(1, RecordingHandler.afterInsertCalls);
        Assert.areEqual(1, RecordingHandler.afterUpdateCalls);
        Assert.areEqual(2, RecordingHandler.runAfterCalls);
    }

    private static ApexRailContext contextFor(
        System.TriggerOperation operation
    ) {
        return new ApexRailContext(operation, null, null, null, null);
    }

    private static void resetState() {
        ApexRailGuard.reset();
        ApexRailControl.reset();
        RecordingHandler.beforeUpdateCalls = 0;
        RecordingHandler.afterInsertCalls = 0;
        RecordingHandler.afterUpdateCalls = 0;
        RecordingHandler.runAfterCalls = 0;
    }
}
