# Flow and Apex ownership

ApexRail complements Flow. It does not compete with it.

| Requirement | Likely owner |
|---|---|
| Simple same-record derivation | Before-save Flow |
| Admin-owned notification | After-save Flow |
| Complex cross-record invariant | Apex domain service |
| High-volume calculation | Apex |
| Durable external request creation | Apex application service |
| HTTP delivery and retry | Asynchronous Apex or middleware |

The team should select one owner for each business rule. A Flow and an Apex action must not implement the same rule independently.

For highly automated objects, maintain a table containing the automation name, owner, event, order dependency, records touched, asynchronous work and failure policy.
