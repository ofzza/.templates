# Template-DotNet

[![NuGet](https://img.shields.io/nuget/vpre/Template.DotNet)](https://www.nuget.org/packages/Template.DotNet/)

.NET project template: a `net10.0` solution with documentation, CI, packing and publishing preconfigured, ready for projects to be added under `src/`, `tests/` and `samples/`.

---

Jump to section:

- [Get Template-DotNet](#get-template-dotnet)
- [Usage](#usage)
- [Development](#development)
- [Contributing](#contributing)

# Get Template-DotNet

Template-DotNet is published as a NuGet package:

```sh
$ dotnet add package Template.DotNet
```

Requires `net10.0` or later.

# Usage

_Describe how to use the package here, with a section per public type or feature._

# Development

Requires the .NET 10 SDK.

| Path              |                                                                      |
| ----------------- | -------------------------------------------------------------------- |
| `src/`            | Library and application projects                                     |
| `tests/`          | Test projects                                                        |
| `samples/`        | Sample projects demonstrating usage                                  |
| `scripts/pack.sh` | Packs every packable project into `artifacts/packages`               |
| `PUBLISH.md`      | Release checklists and the steps to publish to nuget.org             |
| `icon.png`        | The package icon                                                     |

- `dotnet build Template.DotNet.slnx` - builds every project.
- `dotnet test Template.DotNet.slnx` - runs every test project.
- `./scripts/pack.sh` - packs every packable project, in Release, into `artifacts/packages`. Extra arguments are passed on to `dotnet pack`, e.g. `./scripts/pack.sh -p:Version=0.2.0`.

GitHub Actions runs restore, build, test and pack on every pull request targeting, and every push to, `master` or `develop`, on both Ubuntu and Windows.

# Contributing

For reporting issues, contribution workflow and branching, see [CONTRIBUTE.md](./CONTRIBUTE.md). For releasing a version, see [PUBLISH.md](./PUBLISH.md).

MIT - see [LICENSE.md](./LICENSE.md).
