# Interview guide

## Thirty-second description

> I designed ApexRail, a standalone Salesforce trigger framework for deterministic, bulk-safe record automation. It uses one thin trigger per object, lifecycle handlers and explicitly ordered actions. It controls re-entry by action and record rather than disabling the entire trigger with a static Boolean. Business logic remains in domain services, and external delivery crosses a durable asynchronous boundary.

## Architecture discussion

Be prepared to explain:

1. Why multiple triggers make ordering difficult.
2. Why a handler is orchestration rather than a business-logic container.
3. How collection-first interfaces encourage bulkification.
4. The difference between duplicate execution and legitimate re-entry.
5. Why compile-time action order was chosen over metadata reflection.
6. What ApexRail can and cannot control in Salesforce order of execution.
7. Why a committed Opportunity does not prove that an external system received it.
8. How security mode is selected deliberately by the application.

## Honest boundaries

Do not claim that ApexRail solves all Salesforce automation. State plainly that it does not order Flow, replace an event bus, provide cross-transaction idempotency, or remove governor limits. Its value is disciplined orchestration and clear extension points.

## Mapato example

Use the Opportunity-to-Mapato scenario to demonstrate transition detection, durable intent, idempotency, Queueable callouts, retry state and operational evidence.
