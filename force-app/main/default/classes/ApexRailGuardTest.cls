@IsTest
private class ApexRailGuardTest {
    @IsTest
    static void guardTracksRecordsPerAction() {
        ApexRailGuard.reset();
        Id firstId = TestUtility.idFor(Account.SObjectType, 1);
        Id secondId = TestUtility.idFor(Account.SObjectType, 2);

        Set<Id> firstPass = ApexRailGuard.retainUnprocessed(
            'Account.Notify',
            new Set<Id>{firstId, secondId}
        );
        Set<Id> secondPass = ApexRailGuard.retainUnprocessed(
            'Account.Notify',
            new Set<Id>{firstId, secondId}
        );
        Set<Id> anotherAction = ApexRailGuard.retainUnprocessed(
            'Account.Audit',
            new Set<Id>{firstId}
        );

        Assert.areEqual(2, firstPass.size());
        Assert.areEqual(0, secondPass.size());
        Assert.areEqual(new Set<Id>{firstId}, anotherAction);
    }

    @IsTest
    static void blankActionNameIsRejected() {
        try {
            ApexRailGuard.retainUnprocessed(null, new Set<Id>());
            Assert.fail('Expected ApexRailException.');
        } catch (ApexRailException expected) {
            Assert.isTrue(expected.getMessage().contains('action name'));
        }
    }

    @IsTest
    static void executionKeyCanOnlyBeEnteredOnce() {
        ApexRailGuard.reset();

        Assert.isTrue(ApexRailGuard.enterOnce('AccountHandler:AFTER_UPDATE'));
        Assert.isFalse(ApexRailGuard.enterOnce('AccountHandler:AFTER_UPDATE'));
        Assert.isTrue(ApexRailGuard.enterOnce('AccountHandler:AFTER_INSERT'));
        Assert.isTrue(ApexRailGuard.enterOnce('ContactHandler:AFTER_UPDATE'));
    }

    private class TestUtility {
        static Id idFor(Schema.SObjectType objectType, Integer numberValue) {
            String prefix = objectType.getDescribe().getKeyPrefix();
            return (Id) (prefix + String.valueOf(numberValue).leftPad(12, '0'));
        }
    }
}
