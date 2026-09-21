# Bulkification

Bulk safety is an API design decision, not a final optimisation.

## Rules

1. Actions receive record collections.
2. Services accept sets or lists rather than a single ID.
3. Collect query keys before issuing SOQL.
4. Query once for the transaction wherever practical.
5. Build DML collections and write once.
6. Treat partial success as an explicit business decision.
7. Test with 200 records and meaningful related data.

Prefer:

```apex
MapatoOnboardingService.requestOnboarding(opportunityIds);
```

over:

```apex
for (Id opportunityId : opportunityIds) {
    MapatoOnboardingService.requestOnboarding(opportunityId);
}
```

Selectors and repositories can centralise queries and writes, but ApexRail does not require a particular data-access framework.

## Governor evidence

A bulk test should assert business outcomes first. It can additionally record query and DML consumption around the operation to expose accidental per-record work during review.
