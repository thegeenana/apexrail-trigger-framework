# ADR-0004: Integration outside the framework core

**Status:** Accepted

## Decision

ApexRail contains no HTTP client, retry engine, outbox object or remote-system configuration.

## Rationale

The framework governs transaction-local trigger orchestration. Delivery guarantees, payload contracts and recovery policies belong to the consuming application or integration platform.
