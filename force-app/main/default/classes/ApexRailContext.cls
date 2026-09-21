public inherited sharing class ApexRailContext {
    public System.TriggerOperation operation { get; private set; }
    public List<SObject> newRecords { get; private set; }
    public List<SObject> oldRecords { get; private set; }
    public Map<Id, SObject> newMap { get; private set; }
    public Map<Id, SObject> oldMap { get; private set; }

    public ApexRailContext(
        System.TriggerOperation operation,
        List<SObject> newRecords,
        List<SObject> oldRecords,
        Map<Id, SObject> newMap,
        Map<Id, SObject> oldMap
    ) {
        this.operation = operation;
        this.newRecords = newRecords;
        this.oldRecords = oldRecords;
        this.newMap = newMap;
        this.oldMap = oldMap;
    }

    public static ApexRailContext fromTrigger() {
        if (!Trigger.isExecuting) {
            throw new ApexRailException(
                'ApexRailContext.fromTrigger() requires trigger execution.'
            );
        }

        return new ApexRailContext(
            Trigger.operationType,
            Trigger.new,
            Trigger.old,
            Trigger.newMap,
            Trigger.oldMap
        );
    }
}
