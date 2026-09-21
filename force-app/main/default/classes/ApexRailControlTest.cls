@IsTest
private class ApexRailControlTest {
    @IsTest
    static void bypassCanBeResumedWithinTransaction() {
        ApexRailControl.reset();

        ApexRailControl.bypass('AccountTriggerHandler');
        Assert.isTrue(ApexRailControl.isBypassed('AccountTriggerHandler'));

        ApexRailControl.resume('AccountTriggerHandler');
        Assert.isFalse(ApexRailControl.isBypassed('AccountTriggerHandler'));
    }
}
