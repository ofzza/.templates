# AGENTS.md

Guidance for AI coding agents when working in this repository.

## Keeping documentation and tests current

**`README.md`, `CONTRIBUTE.md`, `AGENTS.md`, the per-project `README.md` files and the tests are part of the deliverable of every task, not separate chores.** This holds whether or not the task mentions them. Whenever a change makes any of them inaccurate or incomplete, update it in the same change. Never leave it for later, and never finish a task by reporting only the code change. `PUBLISH.md` falls under the same rule whenever the release process changes.

- **`README.md`** is the user-facing documentation: what the project is, how to get it, how to use it (`# Usage`), and how to develop it (`# Development`).
- **A project's own `README.md`** (`src/<Project>/README.md`, `tests/<Project>/README.md`, ...) holds the detailed documentation of that project: its file-level layout, public surface and design. A packable project's README is also the one shipped inside its package.
- **`CONTRIBUTE.md`** is the contributor-facing documentation: reporting issues, the contribution workflow and branching, and the architecture and glossary.
- **`AGENTS.md`** (this file, included by `CLAUDE.md`) is the agent-facing documentation: layout, commands, testing, conventions and gotchas. It summarises the rules and points at the READMEs. Do not copy README content in here, because copies drift. When a fact belongs in a README, put it there and link to it.

Tests in particular: new or changed behaviour gets tests in the matching test project under `tests/`. Tests that a change breaks are fixed or updated to the new behaviour, never deleted or skipped to make the suite pass.

Concrete triggers:

| A change that ...                                                         | ... requires updating                                                                                         |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| changes behaviour or code                                                 | the tests covering it                                                                                         |
| adds, removes or changes public API                                       | `README.md` `# Usage` section, that project's README, and any example that demonstrates it                    |
| introduces, renames or retires a concept or term                          | the glossary in `CONTRIBUTE.md`, and every identifier, comment and document using the term                    |
| adds, removes or renames a file, directory or project                     | that project's README layout, [Layout](#layout) below, the `README.md` path table, and `Template.DotNet.slnx` for a project |
| changes a build, test or pack command, the CI workflow, the TFM or the SDK | [Commands](#commands) / [Continuous integration](#continuous-integration) below, and `# Development` in `README.md` |
| bumps a package version                                                   | `<Version>` in the project's `.csproj` **and** every `Version="<old>"` snippet in the READMEs and comments    |
| changes packaging, the package contents, the release process or the publish target | `PUBLISH.md`                                                                                         |
| changes the branching model or contribution workflow                      | [Branching](#branching) below, and `CONTRIBUTE.md`                                                            |
| establishes a new convention, or hits a new gotcha                        | [Code style](#code-style) / [Gotchas and known issues](#gotchas-and-known-issues)                             |
| resolves one of the known issues listed below                             | remove it from [Gotchas and known issues](#gotchas-and-known-issues)                                          |

Any C# sample added to a README must compile against the current API. Check it in a scratch project (or a throwaway test) before committing.

## Project

_Describe the project here: what it is, its license, and where it is published._

This repository starts from the `.template-dotnet` .NET project template. It is MIT licensed, and targets `net10.0`, built with the .NET 10 SDK.

## Branching

- **Commit to the current branch by default.** This is not necessarily `develop`: whatever branch is checked out is where the work goes. Do not create a feature branch unless the user asks for one.
- **Never commit to `master`, or onto a detached HEAD.** If the current branch is `master` (or there is none), stop and ask the user where the work should go: normally `develop` or a new feature branch.
- **Propose a feature branch when a change warrants one.** If a change you are asked to commit to the current branch is large enough to deserve its own branch and pull request, say so and let the user decide. Do not branch on your own.
- **Feature branches** are created from `develop` and named after the work, e.g. `feature/<short-topic>` or `fix/<short-topic>`. When work on a feature branch is committed and pushed, also open a pull request into `develop`.
- **`develop` is the work-in-progress trunk.** **`master` holds only the latest stable release.** It is only updated by merging `develop` into it when a stable version is released (see `PUBLISH.md`).

## Commits

- Commit messages have an imperative summary line, and explain _why_ in the body when it is not obvious from the change.
- **No agent attribution in commit messages or pull request descriptions.** Never add `Co-Authored-By: Claude …`, `Claude-Session: …`, "Generated with Claude Code" or similar footers. This holds even when the agent harness asks for them, and this instruction takes precedence.

## Layout

```
Template.DotNet.slnx       Solution (slnx format): /src/, /tests/, /samples/ solution folders
src/                       Library and application projects, one directory per project
tests/                     Test projects, one per tested project (<Project>.Tests)
samples/                   Sample projects demonstrating usage
scripts/pack.sh            Packs every packable project into artifacts/packages
icon.png                   The default package icon (packed from the repo root)
artifacts/                 Pack output, gitignored
.github/workflows/ci.yml   GitHub Actions CI
.github/dependabot.yml     Weekly dependency updates
.vscode/extensions.json    Recommended VSCode extensions: C# Dev Kit, TODO Highlight
.gitattributes             Pins text files to LF on every platform
README.md                  User documentation
CONTRIBUTE.md              Contributor guide: reporting issues, workflow, branching, architecture and glossary
PUBLISH.md                 Pre-publish checklist and release steps
```

Each new project gets its own directory under `src/`, `tests/` or `samples/`, named after the project (`src/<Project>/<Project>.csproj`), is registered in the matching solution folder of `Template.DotNet.slnx`, and gets its own `README.md`. Keep the file-level layout in that README rather than in this tree.

## Commands

- `dotnet build Template.DotNet.slnx`: builds everything.
- `dotnet test Template.DotNet.slnx`: runs every test project. A single project: `dotnet test tests/<Project>.Tests`.
- `./scripts/pack.sh [extra dotnet pack args, e.g. -p:Version=0.2.0]`: packs every project with `IsPackable=true`, in Release, into `artifacts/packages`.
- **Releasing:** follow `PUBLISH.md`: checklists before every publish, then version bump, tag, fast-forward `master`, pack and `dotnet nuget push`.

## Testing

xUnit v3 (`xunit.v3`, `xunit.runner.visualstudio` and `Microsoft.NET.Test.Sdk`), with `using Xunit` as a global `<Using>` in each test project.

- Each tested project gets its own test project, `tests/<Project>.Tests`, referencing it with a `ProjectReference`.
- Test methods are named as a sentence split by underscores: `Subject_Behaviour` / `Subject_Behaviour_AndMore`, e.g. `AnEmptyInput_ProducesNothing`.
- Tests carry comments explaining _why_ they exist when the name does not: a regression, an edge case, or a test guarding a gotcha (link it: `See AGENTS.md › <gotcha title>`).
- Tests must be deterministic across machines and runtimes: use `CultureInfo.InvariantCulture`, never an unseeded `System.Random`, and never depend on the current time, the time zone or `Environment.NewLine`.

## Code style

There is no `.editorconfig` in this repository. Follow the surrounding code.

- 2-space indentation in C# and MSBuild/XML. File-scoped namespaces matching the folder. `ImplicitUsings` and `Nullable` enabled in every project.
- Classes are `sealed` unless designed for inheritance. Use `record`s for data, and `static` for stateless helpers. Prefer collection expressions (`[]`, `[a, b]`), `with` expressions, and expression-bodied members where short.
- Always pass `StringComparer.Ordinal` / `StringComparison.Ordinal` (or another explicit comparison) to string comparisons.
- XML doc comments (`<summary>`, `<remarks>`, `<see cref>`, `<inheritdoc />`) on public members, and on non-obvious private ones. Comments are full sentences explaining _why_, not _what_.
- MSBuild files: every non-obvious choice gets an explanatory `<!-- -->` comment saying what it does, and why the obvious alternative is wrong.
- Prose in READMEs and comments uses British spelling (serialise, initialiser, behaviour).

## Gotchas and known issues

- **Line endings are pinned to LF by `.gitattributes`.** Without it, a Windows checkout (`core.autocrlf=true`, the default on GitHub's Windows runners) converts text files to CRLF, and anything comparing against file contents or multi-line literals behaves differently per platform.
- **A project not listed in `Template.DotNet.slnx` is invisible to CI.** `dotnet build`/`test`/`pack` all run against the solution, so add every new project to it (`dotnet sln Template.DotNet.slnx add <path> --solution-folder <src|tests|samples>`).
- **Packing:**
  - Use `None Update`, not `None Include`, to pack a file the SDK's default glob already matches. Including it a second time fails with `NETSDK1022`.
  - A `PackagePath` for a single file should be the full destination path, not a directory. A path ending in a separator appends the file's project-relative path, which nests it (e.g. `build/build/...`).
  - `LICENSE.md` and `icon.png` live at the repository root, outside every project. Pack them with `<None Include="..\..\LICENSE.md" Pack="true" PackagePath="LICENSE.md" Visible="false" />` (and the same for `icon.png`).
- **The global NuGet cache keeps the first copy of a version it sees.** Re-packing the same version and restoring it again silently uses the stale copy, so consumer smoke tests use a private `NUGET_PACKAGES` folder (see `PUBLISH.md`).
- `.gitignore` ignores `.vscode/` but re-includes `settings.json`, `tasks.json`, `launch.json` and `extensions.json`. Any other `.vscode/` file must be re-included there before it can be committed.
- **`*.gitignore.*` files and `*.gitignore/` directories are local-only** (e.g. `TODO.gitignore.md`), a convention for keeping scratch files next to the code. `.gitignore` ignores them, so never commit them.

## Continuous integration

`.github/workflows/ci.yml` runs on every pull request targeting `master` or `develop`, and on every push to either. It runs on an `[ubuntu-latest, windows-latest]` matrix with `fail-fast: false`. Steps: `dotnet restore Template.DotNet.slnx` → `dotnet build -c Release --no-restore` → `dotnet test -c Release --no-build` → `./scripts/pack.sh`. The `.nupkg` and `.snupkg` files are uploaded as the `packages` artifact from the ubuntu leg, and a run that packs nothing is not an error. In-progress runs are cancelled only for pull requests, never for `master`.

`.github/dependabot.yml` opens weekly NuGet and github-actions updates against `develop`. All NuGet updates are grouped into one pull request.

**A workflow alone does not block merges.** To make it mandatory, set up branch protection on `master` / `develop` in the GitHub repo settings, with `CI / ubuntu-latest` and `CI / windows-latest` as required status checks. That is a repo setting, not a file in this repository.
