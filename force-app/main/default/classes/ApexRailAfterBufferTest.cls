@IsTest
private class ApexRailAfterBufferTest {
    @IsTest
    static void latestRecordWinsForSameDeduplicationKey() {
        ApexRailAfterBuffer.reset();
        Account firstVersion = new Account(Name = 'First');
        Account finalVersion = new Account(Name = 'Final');

        ApexRailAfterBuffer.register('AccountUpdate', 'account-1', firstVersion);
        ApexRailAfterBuffer.register('AccountUpdate', 'account-1', finalVersion);

        List<SObject> records = ApexRailAfterBuffer.drain('AccountUpdate');

        Assert.areEqual(1, records.size());
        Assert.areEqual('Final', ((Account) records[0]).Name);
        Assert.isFalse(ApexRailAfterBuffer.hasWork('AccountUpdate'));
    }

    @IsTest
    static void workTypesAreIsolated() {
        ApexRailAfterBuffer.reset();
        ApexRailAfterBuffer.register(
            'AccountUpdate',
            'account-1',
            new Account(Name = 'Account')
        );
        ApexRailAfterBuffer.register(
            'ContactUpdate',
            'contact-1',
            new Contact(LastName = 'Contact')
        );

        Assert.areEqual(1, ApexRailAfterBuffer.drain('AccountUpdate').size());
        Assert.isTrue(ApexRailAfterBuffer.hasWork('ContactUpdate'));
    }

    @IsTest
    static void invalidRegistrationIsRejected() {
        try {
            ApexRailAfterBuffer.register('AccountUpdate', null, new Account());
            Assert.fail('Expected ApexRailException.');
        } catch (ApexRailException expected) {
            Assert.isTrue(expected.getMessage().contains('deduplication key'));
        }
    }
}
