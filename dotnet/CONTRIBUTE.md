# Contributing

## Reporting Issues

When reporting issues, please keep to the provided issue templates, if any.

Before reporting issues, please read: [GitHub Work-Flow](https://github.com/ofzza/onboarding/blob/master/CONTRIBUTING/github.md)

## Contributing Code

For work-flow and general etiquette when contributing, please see:

- [Git Source-Control Work-Flow](https://github.com/ofzza/onboarding/blob/master/CONTRIBUTING/git.md)
- [GitHub Work-Flow](https://github.com/ofzza/onboarding/blob/master/CONTRIBUTING/github.md)

This repository uses two long-lived branches:

- `develop` - the work-in-progress trunk.
- `master` - always contains the latest stable released version. It is never committed to directly, and only ever gets merged into from `develop`, when a stable version is released.

Small changes are committed directly to the branch you are working on, usually `develop`. Larger work, or any work you want reviewed, goes in its own feature branch, created from `develop` and named after the work (see [Git Source-Control Work-Flow](https://github.com/ofzza/onboarding/blob/master/CONTRIBUTING/git.md) for branch naming conventions). Once it is pushed, request a merge into `develop` with a pull request. Ideally, accompany such work with its own issue.

Before committing or requesting a merge, make sure `dotnet build Template.DotNet.slnx` and `dotnet test Template.DotNet.slnx` pass locally, and that `README.md`, `CONTRIBUTE.md`, `AGENTS.md` and the affected projects' READMEs reflect the change.

## Architecture and glossary

### Project structure

```
Template.DotNet.slnx    Solution
src/                    Library and application projects
tests/                  Test projects, one per tested project (<Project>.Tests)
samples/                Sample projects demonstrating usage
```

Every project lives in its own directory under `src/`, `tests/` or `samples/`, is registered in the solution, and documents itself in its own `README.md`.

### Glossary

Terms used across code, comments and documentation. Use them as defined here, and add every new concept to this list.

| Term  | Meaning |
| ----- | ------- |
| _TBD_ | _TBD_   |
