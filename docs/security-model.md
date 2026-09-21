# Security model

ApexRail uses `inherited sharing` but does not choose CRUD, field-level security or database access mode for the consuming application.

That is intentional. Triggered business invariants and user-facing operations can require different execution policies.

## Application responsibilities

- declare the sharing model of services;
- select user or system mode explicitly for SOQL and DML;
- enforce object and field access where the use case requires it;
- sanitise untrusted deserialised data;
- permission-gate privileged bypass or reprocessing;
- add negative tests using restricted users;
- document every intentional elevation.

System mode should be narrow, named and reviewable. Do not use the framework as a way to conceal privilege.

## Bypass

Core bypass is transaction-scoped only. A consuming application may add a Custom Permission or Custom Metadata feature switch, but persistent bypass must produce operational evidence of who used it, why, and which records were affected.
