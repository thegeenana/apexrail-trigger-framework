# Execution lifecycle

The trigger constructs an object handler and passes it to `ApexRail.dispatch`. The handler obtains an immutable reference to the current trigger context and invokes exactly one lifecycle hook.

After the relevant after-context hook completes, the handler invokes `runAfter()` once. This is a pipeline finaliser for the current invocation, not a Salesforce Queueable Transaction Finalizer and not an end-of-transaction callback.

| Operation | Typical responsibility |
|---|---|
| Before insert | Defaults, normalisation, validation |
| Before update | Validate transitions and modify the current record |
| Before delete | Prevent invalid deletion |
| After insert | Create dependent records that require an ID |
| After update | React to meaningful state transitions |
| After delete | Cleanup or audit deleted identities |
| After undelete | Restore derived relationships or state |

Prefer changing fields on `Trigger.new` during a before operation. Avoid updating the same records again through DML.

## Transition detection

Actions should compare old and new state:

```apex
if (
    currentRecord.StageName == 'Closed Won' &&
    previousRecord.StageName != 'Closed Won'
) {
    newlyWonIds.add(currentRecord.Id);
}
```

Checking only the current value causes unrelated future updates to repeat the action.

## Complete order of execution

ApexRail controls ordering only inside its own handler pipeline. Before-save Flow, validation, workflow effects, after-save Flow, rollups and other platform automation still participate in Salesforce order of execution. Keep an automation ownership matrix for every high-automation object.
