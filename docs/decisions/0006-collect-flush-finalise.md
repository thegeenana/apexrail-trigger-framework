# ADR-0006: Collect, flush and finalise

**Status:** Accepted

## Decision

After-context methods collect or merge work. `runAfter()` executes once at the end of each ApexRail after-trigger invocation and flushes that work in bulk. A durable asynchronous mechanism is required for genuine once-after-commit finalisation.

## Rationale

Salesforce can invoke a trigger repeatedly in one transaction, but it does not expose a synchronous callback that identifies the final invocation. Suppressing later after invocations can lose records discovered through re-entry.

The framework therefore provides three explicit stages:

```text
afterInsert/Update/Delete/Undelete -> collect
runAfter                            -> flush this invocation
durable async worker                -> finalise after commit
```

## Consequences

- Implementers keep DML out of collection loops.
- A deduplication key determines which buffered record wins.
- Trigger re-entry may cause another bulk flush; it is not silently discarded.
- Cross-transaction idempotency requires persisted keys.
- `runAfter()` must not be confused with Salesforce's Queueable Transaction Finalizer.
