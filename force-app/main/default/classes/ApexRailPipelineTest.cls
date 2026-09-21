@IsTest
private class ApexRailPipelineTest {
    private class RecordingAction implements ApexRailAction {
        private String value;
        private List<String> record;

        RecordingAction(String value, List<String> record) {
            this.value = value;
            this.record = record;
        }

        public void execute(ApexRailContext context) {
            record.add(value);
        }
    }

    @IsTest
    static void actionsRunInDeclaredOrder() {
        List<String> execution = new List<String>();
        ApexRailContext context = new ApexRailContext(
            System.TriggerOperation.BEFORE_INSERT,
            new List<SObject>(),
            null,
            null,
            null
        );

        ApexRailPipeline.execute(
            new List<ApexRailAction>{
                new RecordingAction('validate', execution),
                new RecordingAction('normalise', execution),
                new RecordingAction('prepare', execution)
            },
            context
        );

        Assert.areEqual(
            new List<String>{'validate', 'normalise', 'prepare'},
            execution
        );
    }

    @IsTest
    static void emptyPipelineDoesNothing() {
        ApexRailPipeline.execute(new List<ApexRailAction>(), null);
        Assert.isTrue(true);
    }

    @IsTest
    static void nullActionIsRejected() {
        ApexRailContext context = new ApexRailContext(
            System.TriggerOperation.BEFORE_INSERT,
            new List<SObject>(),
            null,
            null,
            null
        );

        try {
            ApexRailPipeline.execute(
                new List<ApexRailAction>{null},
                context
            );
            Assert.fail('Expected ApexRailException.');
        } catch (ApexRailException expected) {
            Assert.isTrue(expected.getMessage().contains('null action'));
        }
    }
}
