# Asynchronous integration

ApexRail stops at the transaction boundary. A record trigger should not treat a direct remote call as proof of durable delivery.

## Transactional outbox pattern

```mermaid
sequenceDiagram
    participant U as User
    participant A as ApexRail action
    participant R as Integration request
    participant Q as Queueable worker
    participant X as External system

    U->>A: Commit business change
    A->>R: Insert PENDING intent
    A->>Q: Register request IDs
    A-->>U: Salesforce transaction commits
    Q->>R: Load committed intent
    Q->>X: Deliver idempotent request
    X-->>Q: Response
    Q->>R: Record outcome
```

Suggested statuses are `PENDING`, `IN_PROGRESS`, `SUCCEEDED`, `RETRY_WAIT`, `FAILED`, and `DEAD_LETTER`.

One Queueable is normally sufficient when the trigger transaction creates the request and the Queueable performs the callout before updating the result. Separate jobs are justified when payload preparation requires its own DML transaction, mixed DML must be isolated, aggregation is required, or stages need independent retry policies.

The outbox record should carry an idempotency key, correlation ID, source record, operation, attempt count, next attempt time and sanitised failure information.
