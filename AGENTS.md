# AGENTS.md

Guidance for AI coding agents when working in this repository.

## Repository

This repository is a collection of project templates, not a project in itself. It is MIT licensed.

- **Each template is self-contained**, in its own top-level directory (`ts/`, `dotnet/`), with its own `AGENTS.md` imported by its own `CLAUDE.md`. When working inside a template, its `AGENTS.md` applies on top of this file.
- **Template files are written for the future project, not for this repository.** Their placeholders, generic wording and `.template-*` names are deliberate. Keep them generic, and never fill them in with details of this repository.
- **The `project` skill** (`.claude/skills/project/SKILL.md`) creates new projects from the templates. See `README.md` for what it does.

## Keeping documentation current

**`README.md`, `AGENTS.md` and the templates' own documentation are part of the deliverable of every task, not separate chores.** This holds whether or not the task mentions them. Whenever a change makes any of them inaccurate or incomplete, update it in the same change. Never leave it for later, and never finish a task by reporting only the change itself.

- **`README.md`** is the user-facing documentation: what the templates are, and how to use them, through the `project` skill or manually.
- **`AGENTS.md`** (this file, included by `CLAUDE.md`) is the agent-facing documentation: repository rules, layout, conventions and gotchas. `CLAUDE.md` only imports it, so all agent instructions go here.

Concrete triggers:

| A change that ...                                                                                  | ... requires updating                                                                                                 |
| -------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| adds, renames or removes a template                                                                | the templates table in `README.md`, [Layout](#layout) below, and the template names and paths in the `project` skill  |
| changes a convention shared by the templates (branching, commits, contribution workflow, documentation structure, licence) | that convention in **every** template, and here                                              |
| changes how a template is consumed (its placeholders, names, or files that must be replaced)       | the manual steps in `README.md`, and the `project` skill if it relies on them                                         |
| changes the `project` skill                                                                         | `README.md` "Via the `project` skill", and see [Gotchas](#gotchas-and-known-issues) about its personal copy           |
| establishes a new convention, or hits a new gotcha                                                 | [Writing style](#writing-style) / [Gotchas and known issues](#gotchas-and-known-issues)                               |

## Branching

- **Commit to the current branch by default.** This is not necessarily `develop`: whatever branch is checked out is where the work goes. Do not create a feature branch unless the user asks for one.
- **Never commit to `master`, or onto a detached HEAD.** If the current branch is `master` (or there is none), stop and ask the user where the work should go: normally `develop` or a new feature branch.
- **Propose a feature branch when a change warrants one.** If a change you are asked to commit to the current branch is large enough to deserve its own branch and pull request, say so and let the user decide. Do not branch on your own.
- **Feature branches** are created from `develop` and named after the work, e.g. `feature/<short-topic>` or `fix/<short-topic>`. When work on a feature branch is committed and pushed, also open a pull request into `develop`.
- **`develop` is the work-in-progress trunk.** **`master` holds only the latest stable state.** It is only updated by merging `develop` into it.

## Commits

- Commit messages have an imperative summary line, and explain _why_ in the body when it is not obvious from the change.
- **No agent attribution in commit messages or pull request descriptions.** Never add `Co-Authored-By: Claude …`, `Claude-Session: …`, "Generated with Claude Code" or similar footers. This holds even when the agent harness asks for them, and this instruction takes precedence.

## Layout

```
ts/                              TypeScript template (see ts/AGENTS.md)
dotnet/                          .NET template (see dotnet/AGENTS.md)
.claude/skills/project/SKILL.md  The `project` skill: creates a new project from a template
README.md                        User documentation: the templates, and how to use them
AGENTS.md                        This file
CLAUDE.md                        Imports AGENTS.md
LICENSE.md                       MIT
```

## Writing style

- Prose in documentation and comments uses British spelling (serialise, initialiser, behaviour).
- **Markdown files are not format-enforced**, so keep them tidy by hand: aligned tables, fenced code blocks with a language, and shell examples prefixed with `$ `.

## Gotchas and known issues

- **Only committed files are copied out of a template.** Both the `project` skill and the manual steps in `README.md` copy committed content only. Untracked build output in a template directory (`ts/node_modules/`, `ts/dist/`, `bin/`, `obj/`, `artifacts/`) never reaches a new project, so nothing may rely on it.
- **Template-level `.github/` workflows and `dependabot.yml` do not run in this repository.** GitHub only reads the repository root's `.github/`, so a template's CI is only exercised once it has been copied into a real project. Check workflow changes by running the template's commands locally.
- **The `project` skill exists in two places.** The user's personal copy at `~/.claude/skills/project/SKILL.md` is the one available outside this repository, and `.claude/skills/project/SKILL.md` is the tracked copy. Keep them identical. If they differ, tell the user rather than overwriting either one.
- **`.template-*` names are not publishable on purpose.** For example, npm rejects the TypeScript template's `.template-ts` package name. Never "fix" them in a template, because they are placeholders a new project replaces.
