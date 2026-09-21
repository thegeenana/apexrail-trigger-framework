# Recursion and re-entry

Salesforce automation can update a record more than once in one transaction. Calling all of that behaviour “recursion” hides an important distinction:

- **duplicate execution** repeats work that has already been completed;
- **legitimate re-entry** processes a new state produced later in the transaction.

## ApexRail lifecycle policy

ApexRail distinguishes before and after behaviour:

| Context | Policy |
|---|---|
| Before insert/update/delete | Run on every invocation |
| After insert | Collect, then call `runAfter()` once for this invocation |
| After update | Collect, then call `runAfter()` once for this invocation |
| After delete | Collect, then call `runAfter()` once for this invocation |
| After undelete | Collect, then call `runAfter()` once for this invocation |

`ApexRailHandler.run()` dispatches the context-specific method and invokes `runAfter()` immediately afterwards. The context method should collect or merge work; `runAfter()` should flush it in bulk.

If Flow, workflow or Apex causes trigger re-entry, another invocation occurs and another collect-and-flush cycle is allowed. Suppressing that invocation could discard newly discovered work.

## Why not one global Boolean?

```apex
if (TriggerState.hasRun) return;
```

This disables every context indiscriminately and can discard records introduced by later automation. ApexRail does not use a global Boolean to suppress its after lifecycle.

## Collect and flush

```apex
protected override void afterUpdate() {
    ApexRailAfterBuffer.register(
        'MapatoOnboarding',
        opportunity.Id,
        request
    );
}

protected override void runAfter() {
    List<SObject> records = ApexRailAfterBuffer.drain('MapatoOnboarding');
    if (!records.isEmpty()) {
        Database.insert(records, false);
    }
}
```

The map gives one latest record per deduplication key and the flush gives one bulk DML statement for that invocation.

See the complete [Opportunity example](../examples/opportunity), which collects follow-up Tasks for Opportunities entering `Closed Won` and inserts the batch inside `runAfter()`.

## Per-action and per-record guard

```apex
Set<Id> remainingIds = ApexRailGuard.retainUnprocessed(
    'Opportunity.CreateMapatoRequest',
    candidateIds
);
```

This second guard is available when an application needs more precise protection inside an allowed lifecycle run. It scopes state by action name and record ID. Another action remains free to process the same record.

## Limits

Before-insert records do not yet have IDs. Do not invent a universal workaround. An application can use a stable business key, a narrowly scoped pass counter, or design the action to be naturally idempotent.

There is no ordinary synchronous trigger callback meaning “all trigger re-entry has finished.” A true once-after-commit final step must persist intent and use Queueable Apex, Platform Events or another asynchronous mechanism. Static state is transaction-local; each later transaction receives fresh state.
