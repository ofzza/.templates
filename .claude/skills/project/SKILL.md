---
name: project
description: Manages a project repository
arguments: [new] [template]
---

# Project

## New project

> This subcommand executes only if $new argument is present

1. If $template is present but does not have a value set or the value set for it is not one of the following (ignoring case): `typescript`, `ts`, `dotnet`, `.net`
   ... ask the user in a dialog (`AskUserQuestion`) to select which template to use. Available options should be:
   - Typescript
   - .NET

   The user selected option should be considered as the new value for $template in all future steps

2. Check if a relative path of `../.templates` to the current working directory exists. If not ask the user in a dialog (`AskUserQuestion`) to enter the path where the templates repository (https://github.com/ofzza/.templates) has been cloned.
   Other than just entry of the path, provide the user with an alternative option of allowing you to clone the repository into a tmp location for the user.

   In any case, whether the relative path `../.templates` exists and is a clone of the `https://github.com/ofzza/.templates` repo, or the user pointed you to a different path that is a clone of the `https://github.com/ofzza/.templates` repo, or you yourself had cloned the `https://github.com/ofzza/.templates` repo in a temp location, from this point on consider $path to refer to the path on the local machine with the `https://github.com/ofzza/.templates` repo cloned to it.

3. If $template was selected to be (ignoring case):

- `typescript` or `ts`, copy recursively all the committed content of `$path/ts` into the working directory.
- `dotnet` or `.net`, copy recursively all the committed content of `$path/dotnet` into the working directory.

4. Analyze all of the copied files and find:

- Project name references that are referring to the template this was copied from and now need to be replaced with a specific project name
- Project version that might need to be updated
- Project `README.md`, `CONTRIBUTE.md`, `PUBLISH.md` documentation that might need to be made more specific and descriptive of the current project
- Project `AGENTS.md` files that might be containing placeholders that need to be updated for this particular project

When done analyzing all the files, prompt the user in a dialog (`AskUserQuestion`) to provide you with any and all information and clarification you feel that you need to update all the items you found need to be updated for the content in this repo to correctly reflect the project that was created and not the template it was created from.

5. If the current directory is not a git repo:

- Initialize it as a git repo
- Create a `master` branch
- Stage and commit all the files with the commit message "Initial commit"
- Check out a `develop` branch from the `master` branch
