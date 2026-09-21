# Recursion and re-entry

Salesforce automation can update a record more than once in one transaction. Calling all of that behaviour “recursion” hides an important distinction:

- **duplicate execution** repeats work that has already been completed;
- **legitimate re-entry** processes a new state produced later in the transaction.

## Why not a global Boolean?

```apex
if (TriggerState.hasRun) return;
```

This disables the complete trigger after its first invocation and can discard valid records or valid second-pass behaviour.

## ApexRail guard

```apex
Set<Id> remainingIds = ApexRailGuard.retainUnprocessed(
    'Opportunity.CreateMapatoRequest',
    candidateIds
);
```

The guard scopes state by action name and record ID. Another action remains free to process the same record.

## Limits

Before-insert records do not yet have IDs. Do not invent a universal workaround. An application can use a stable business key, a narrowly scoped pass counter, or design the action to be naturally idempotent.

Static state is transaction-local. It does not provide idempotency across asynchronous jobs or separate transactions. Durable integration idempotency requires persisted keys and downstream enforcement.
