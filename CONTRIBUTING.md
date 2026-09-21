# Contributing

Thank you for improving ApexRail.

## Design expectations

- Keep the trigger entry point thin.
- Keep the framework independent of business objects.
- Accept collections at service boundaries.
- Do not add SOQL, DML or callouts to framework classes.
- Make execution order visible.
- Add tests for bulk behaviour and re-entry.
- Record significant architectural changes as an ADR.

## Workflow

1. Create a focused branch.
2. Add or update tests and documentation.
3. Run `bash scripts/validate-structure.sh`.
4. Open a pull request explaining the problem, decision and trade-offs.

Public API expansion requires evidence from a concrete use case. Generality alone is not sufficient.

## Recognition

The project was created and is led by George Wiafe. Additional contributors are recognised through Git commit history, accepted pull requests and release notes where appropriate. See [AUTHORS.md](AUTHORS.md).
