# Account example

This deliberately small example demonstrates the intended separation:

- `AccountTrigger` is only an entry point.
- `AccountTriggerHandler` chooses the lifecycle pipeline.
- `AccountNameNormalisationAction` performs one independently testable task.

The directory is outside the default Salesforce package because ApexRail should not install opinionated automation on subscriber standard objects.
