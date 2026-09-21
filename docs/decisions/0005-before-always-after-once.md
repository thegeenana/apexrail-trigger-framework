# ADR-0005: Before always, after once

**Status:** Accepted

## Decision

ApexRail executes before-trigger lifecycle methods on every invocation. It executes each after-trigger lifecycle method once per handler and trigger operation within an Apex transaction.

The execution key is:

```text
handler name + trigger operation
```

`after insert` and `after update` therefore have separate keys. A repeated invocation of the same handler’s `after update` is suppressed.

## Rationale

Before logic commonly normalises and validates the current record state and may legitimately be evaluated again. After logic is more likely to create dependent records, publish events or register asynchronous work; repeating those side effects is dangerous.

A single unscoped Boolean was rejected because it can suppress a different lifecycle operation that has not run.

## Consequences

- Re-entered records are not passed to the same after operation a second time.
- Applications must put essential same-transaction second-pass calculations in before logic or design an explicit alternative.
- The guarantee ends with the transaction. Durable idempotency is still required across transactions.
