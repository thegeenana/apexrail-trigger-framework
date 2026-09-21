# ADR-0001: One trigger per object

**Status:** Accepted

## Decision

An ApexRail application uses one Apex trigger for each sObject and delegates immediately to one object handler.

## Consequences

Execution inside ApexRail is visible and ordered. Teams must migrate existing triggers carefully and retain the behaviour of unrelated managed-package automation that they do not control.
