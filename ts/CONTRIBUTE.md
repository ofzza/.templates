# Contributing

## Reporting Issues

When reporting issues, please keep to the provided issue templates, if any.

Before reporting issues, please read: [GitHub Work-Flow](https://github.com/ofzza/onboarding/blob/master/CONTRIBUTING/github.md)

## Contributing Code

For work-flow and general etiquette when contributing, please see:

- [Git Source-Control Work-Flow](https://github.com/ofzza/onboarding/blob/master/CONTRIBUTING/git.md)
- [GitHub Work-Flow](https://github.com/ofzza/onboarding/blob/master/CONTRIBUTING/github.md)

This repository uses two long-lived branches:

- `develop` - the work-in-progress trunk. **Create all feature branches from `develop`, and target all pull requests at `develop`.**
- `master` - always contains the latest stable released version. It only ever gets merged into from `develop`, when a stable version is released.

Please accompany any work, fix or feature with its own issue, in its own branch (see [Git Source-Control Work-Flow](https://github.com/ofzza/onboarding/blob/master/CONTRIBUTING/git.md) for branch naming conventions), and once done, request merge via pull request.

Before requesting a merge, make sure `npm run ci` passes locally (build, ESLint, Prettier and tests), and that `README.md`, `CONTRIBUTE.md` and `AGENTS.md` reflect the change.

## Architecture and glossary

### Project structure

```
src/
  index.ts          Entry point and public API
  index.test.ts     Tests, colocated with the code they test
```

Every module lives in `src/`, as an `index.ts` + `index.test.ts` pair, and is re-exported from `src/index.ts`.

### Glossary

Terms used across code, comments and documentation. Use them as defined here, and add every new concept to this list.

| Term  | Meaning |
| ----- | ------- |
| _TBD_ | _TBD_   |
