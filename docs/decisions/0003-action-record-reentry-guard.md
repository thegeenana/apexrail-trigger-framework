# ADR-0003: Action-and-record re-entry guard

**Status:** Accepted

## Decision

Re-entry state is keyed by action name and record ID for the current transaction.

## Rationale

A single static Boolean can suppress legitimate second-pass work and later record groups. Narrow scoping prevents duplicate side effects while preserving unrelated actions.
