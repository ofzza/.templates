# .templates

Project templates for [ofzza](https://github.com/ofzza)'s projects. Each template is a ready-to-copy starting point that comes with documentation, agent instructions, CI and publishing preconfigured.

---

Jump to section:

- [Templates](#templates)
- [Using a template](#using-a-template)
  - [Via the `project` skill](#via-the-project-skill)
  - [Manually](#manually)
- [Contributing](#contributing)

# Templates

| Template               | Contents                                                                                              |
| ---------------------- | ----------------------------------------------------------------------------------------------------- |
| [`ts/`](./ts/)         | ESM TypeScript package: `tsc` build, Vitest, ESLint, Prettier, GitHub Actions CI, npm publishing      |
| [`dotnet/`](./dotnet/) | `net10.0` solution scaffold, with no projects yet: GitHub Actions CI, pack script, NuGet publishing   |

Every template carries its own `README.md`, `CONTRIBUTE.md`, `PUBLISH.md`, MIT `LICENSE`, and an `AGENTS.md` imported by `CLAUDE.md`. These describe the template itself, and become the new project's documentation once their placeholders are filled in.

# Using a template

A template can be used either through the `project` skill for [Claude Code](https://claude.com/claude-code), or manually.

## Via the `project` skill

The [`project` skill](./.claude/skills/project/SKILL.md) creates a new project from a template. Run it from Claude Code in the (empty) directory the new project should live in:

```
/project new [ts | typescript | dotnet | .net]
```

It:

1. Picks the template, asking for one if none (or an unknown one) was given.
2. Finds a clone of this repository, at `../.templates` relative to the working directory. Failing that, it asks for the path of a clone, or offers to clone the repository into a temporary location.
3. Copies the template's committed files into the working directory.
4. Finds everything that still refers to the template (names, versions, placeholders in the documentation and `AGENTS.md`), asks for the project's details, and updates it.
5. If the directory is not yet a git repository, initialises one: commits everything to `master` as "Initial commit", then checks out `develop`.

The skill lives in this repository at `.claude/skills/project/SKILL.md`, so it is available automatically when Claude Code runs inside it. To use it from anywhere, copy or symlink it into your personal skills:

```sh
$ mkdir -p ~/.claude/skills
$ ln -s "$PWD/.claude/skills/project" ~/.claude/skills/project
```

More subcommands may be added to the skill over time.

## Manually

1. **Copy the template's committed files** into the new project's directory. Copy only what is committed: a clone may hold untracked build output (`node_modules/`, `dist/`, `bin/`, `obj/`, `artifacts/`) that does not belong in a new project.

   ```sh
   $ git -C <path-to-.templates> archive HEAD <ts|dotnet> | tar -x --strip-components=1
   ```

2. **Replace the template's placeholders.** Start from the "Project" section and the "Gotchas and known issues" of the template's `AGENTS.md`. Examples: the TypeScript template's `.template-ts` package name and `"private": true`, and the .NET template's `Template.DotNet.slnx` solution name and package ids. Then go through `README.md`, `CONTRIBUTE.md` and `PUBLISH.md`.

3. **Create the git repository** with a `master` and a `develop` branch:

   ```sh
   $ git init -b master
   $ git add -A && git commit -m "Initial commit"
   $ git switch -c develop
   ```

# Contributing

This repository follows the same branching model as the templates: `develop` is the work-in-progress trunk, and `master` holds only the latest stable state. See [AGENTS.md](./AGENTS.md) for the conventions that apply to the repository and to every template in it.

MIT - see [LICENSE.md](./LICENSE.md).
