# Recursion and re-entry

Salesforce automation can update a record more than once in one transaction. Calling all of that behaviour “recursion” hides an important distinction:

- **duplicate execution** repeats work that has already been completed;
- **legitimate re-entry** processes a new state produced later in the transaction.

## ApexRail lifecycle policy

ApexRail distinguishes before and after behaviour:

| Context | Policy |
|---|---|
| Before insert/update/delete | Run on every invocation |
| After insert | Once per handler per transaction |
| After update | Once per handler per transaction |
| After delete | Once per handler per transaction |
| After undelete | Once per handler per transaction |

`ApexRailHandler.run()` routes after contexts through `runAfterOnce`. The execution key includes both handler name and trigger operation. An `after insert` followed by an `after update` can therefore execute both lifecycle methods, while the same `after update` cannot run twice.

This protects side effects such as creating related records, publishing events or registering asynchronous work.

## Why not one global Boolean?

```apex
if (TriggerState.hasRun) return;
```

This disables every context indiscriminately. It can suppress an `after update` merely because `after insert` ran first, and it does not state which handler was executed. ApexRail instead scopes the run-once key to handler and after operation.

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

Static state is transaction-local. Each Bulk API chunk or asynchronous job normally runs in another transaction and receives fresh static state. Durable integration idempotency therefore requires persisted keys and downstream enforcement.
