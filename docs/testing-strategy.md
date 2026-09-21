# Testing strategy

## Framework tests

- dispatch rejects invalid input;
- lifecycle routing invokes the correct hook;
- before hooks run on repeated invocation;
- the same after hook runs once per transaction;
- distinct after operations can each run once;
- pipelines preserve declared order;
- null actions fail clearly;
- guards track IDs independently per action;
- bypass can be resumed in the same transaction.

## Application tests

- test actions directly with an `ApexRailContext`;
- test old-to-new transition matrices;
- process 200 records;
- exercise a legitimate second pass;
- prove duplicate work is prevented;
- test partial DML failures;
- run negative security cases;
- mock every callout outcome;
- assert durable statuses rather than debug logs.

## Integration failure matrix

At minimum, cover success, timeout, 400, 401, 409, 429, 500, malformed response and retry exhaustion.

Tests should prove behaviour. Code coverage is a release gate, not the design goal.
