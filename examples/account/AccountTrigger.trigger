trigger AccountTrigger on Account (before insert, before update) {
    ApexRail.dispatch(new AccountTriggerHandler());
}
