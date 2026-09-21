# ADR-0005: Before always, after once

**Status:** Superseded by [ADR-0006](0006-collect-flush-finalise.md)

## Decision

ApexRail previously proposed executing each after-trigger lifecycle method once per handler and trigger operation within a transaction.

The execution key is:

```text
handler name + trigger operation
```

`after insert` and `after update` therefore have separate keys. A repeated invocation of the same handler’s `after update` is suppressed.

## Rationale

Before logic commonly normalises and validates the current record state and may legitimately be evaluated again. After logic is more likely to create dependent records, publish events or register asynchronous work; repeating those side effects is dangerous.

A single unscoped Boolean was rejected because it can suppress a different lifecycle operation that has not run.

## Reason for supersession

Salesforce exposes no reliable synchronous callback identifying the final trigger invocation. Running on the first invocation and suppressing later invocations can discard work discovered during Flow, workflow or Apex re-entry.
