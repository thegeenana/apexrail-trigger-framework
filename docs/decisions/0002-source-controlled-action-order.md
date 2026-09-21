# ADR-0002: Source-controlled action ordering

**Status:** Accepted

## Decision

Handlers declare action instances in execution order in Apex source.

## Rationale

This gives compile-time visibility, predictable packaging, straightforward tests and useful code review. Custom Metadata can configure application behaviour, but the foundation release will not instantiate arbitrary class names from metadata.
