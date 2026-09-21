# Mapato reference architecture

The Mapato connector is the real-world reference for handing transactional trigger work to a reliable asynchronous integration boundary.

```text
Opportunity moves to Closed Won
  -> ApexRail detects the transition
  -> Mapato eligibility action validates commercial data
  -> Integration_Request__c records PENDING intent
  -> a Queueable job is registered
  -> the Salesforce transaction commits
  -> the worker calls Mapato
  -> the request records SUCCEEDED, RETRY_WAIT, FAILED, or DEAD_LETTER
```

The integration runtime is intentionally not part of the ApexRail core. ApexRail governs in-transaction record automation; the application owns its domain and delivery semantics.

See [the asynchronous integration guide](../../docs/async-integration.md).
