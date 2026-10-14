# Publishing

How to release a new version of this package to [NuGet](https://www.nuget.org/). Releases are cut from `develop` and published from `master`, following the branching model in [AGENTS.md](./AGENTS.md#branching).

Below, `<PackageId>` is the package's id (lowercased as `<packageid>` in nuget.org API URLs), `<Project>` the packable project, and `<version>` the version being released.

A version published to nuget.org can never be overwritten or deleted. It can only be unlisted, and anyone who names an unlisted version can still restore it. Treat every push as permanent.

## Packable project setup

A project is only packed once it sets `IsPackable`. A packable project's `.csproj` should carry at least:

```xml
<PropertyGroup>
  <IsPackable>true</IsPackable>
  <PackageId><PackageId></PackageId>
  <Version>0.1.0</Version>
  <Authors>ofzza</Authors>
  <Description>...</Description>
  <PackageLicenseExpression>MIT</PackageLicenseExpression>
  <PackageReadmeFile>README.md</PackageReadmeFile>
  <PackageIcon>icon.png</PackageIcon>
  <PackageTags>...</PackageTags>
  <PackageProjectUrl>https://github.com/ofzza/<repository></PackageProjectUrl>
  <RepositoryUrl>https://github.com/ofzza/<repository></RepositoryUrl>
  <RepositoryType>git</RepositoryType>
</PropertyGroup>

<!-- Symbols ship as a separate .snupkg, which dotnet nuget push picks up from beside the .nupkg. A CI build
     normalises the source paths embedded in the PDBs, so they do not leak the packing machine's directory
     layout. It is switched on automatically under GitHub Actions, and passed explicitly for a release
     packed by hand (see below). -->
<PropertyGroup>
  <IncludeSymbols>true</IncludeSymbols>
  <SymbolPackageFormat>snupkg</SymbolPackageFormat>
  <ContinuousIntegrationBuild Condition="'$(ContinuousIntegrationBuild)' == '' And '$(GITHUB_ACTIONS)' == 'true'">true</ContinuousIntegrationBuild>
</PropertyGroup>

<ItemGroup>
  <None Update="README.md" Pack="true" PackagePath="README.md" />
  <None Include="..\..\LICENSE.md" Pack="true" PackagePath="LICENSE.md" Visible="false" />
  <None Include="..\..\icon.png" Pack="true" PackagePath="icon.png" Visible="false" />
</ItemGroup>
```

## Before each publish

- [ ] **`develop` is clean and in sync with `origin`**: `git status` shows nothing to commit, and `git pull` brings in nothing new.
- [ ] **CI is green** for the head of `develop` on GitHub, on both `CI / ubuntu-latest` and `CI / windows-latest`.
- [ ] **The Release build and tests pass locally**, exactly as CI runs them:

  ```sh
  $ dotnet restore Template.DotNet.slnx
  $ dotnet build Template.DotNet.slnx -c Release --no-restore
  $ dotnet test Template.DotNet.slnx -c Release --no-build
  ```

- [ ] **The documentation matches the code**, per [Keeping documentation and tests current](./AGENTS.md#keeping-documentation-and-tests-current): the `README.md` `# Usage` section and the projects' READMEs cover the public API, and their C# samples compile.
- [ ] **The new version has been chosen** following semver, and does not appear in the list nuget.org already has, which includes unlisted versions:

  ```sh
  $ curl -s https://api.nuget.org/v3-flatcontainer/<packageid>/index.json
  ```

  (A `404` means nothing has been published yet.)

- [ ] **The package contents are right**: after packing (step 2 below), `unzip -l artifacts/packages/<PackageId>.<version>.nupkg` lists `lib/net10.0/<Project>.dll`, `README.md`, `LICENSE.md` and `icon.png`, and nothing from `tests/` or `samples/`. A `<PackageId>.<version>.snupkg` sits next to it. `unzip -p artifacts/packages/<PackageId>.<version>.nupkg <PackageId>.nuspec` shows the right version, license, repository URL, project URL, tags, icon and readme.
- [ ] **The packed package works for a consumer**: see [Consumer smoke test](#consumer-smoke-test) below.
- [ ] **You have a valid nuget.org API key** with push rights to `<PackageId>` (nuget.org → API Keys, scoped to the package's glob). Keys expire, so check the date.
- [ ] **`master` can be fast-forwarded to `develop`**: `git log develop..master` prints nothing. If it prints commits (a hotfix, for example), merge `master` into `develop` first and start this checklist again.

### Consumer smoke test

Restore the packed package into a throwaway project outside the repository. Use a private `NUGET_PACKAGES` folder, because the global package cache keeps the first copy of a version it sees. Re-packing the same version would otherwise test a stale package.

```sh
$ ./scripts/pack.sh -p:Version=<version>
$ mkdir -p /tmp/<packageid>-smoke && cd /tmp/<packageid>-smoke
$ export NUGET_PACKAGES=$PWD/.nuget
$ cat > nuget.config <<EOF
<configuration>
  <packageSources>
    <clear />
    <add key="local" value="<repo>/artifacts/packages" />
    <add key="nuget" value="https://api.nuget.org/v3/index.json" />
  </packageSources>
</configuration>
EOF
$ dotnet new console -n Smoke -f net10.0
$ dotnet add Smoke package <PackageId> --version <version>
$ # Use the package's public API from Smoke/Program.cs
$ dotnet build Smoke
$ dotnet run --project Smoke
```

It passes when the build succeeds with no warnings from the package, and the program runs and exercises the package as documented in `README.md`.

## Packaging and publishing

1. **Bump the version on `develop`.** Set `<Version>` in the packable project's `.csproj`, and every `Version="<old>"` snippet with it. `grep -rn 'Version="<old>"' --include=*.md --include=*.csproj .` finds them. Then commit and tag:

   ```sh
   $ git switch develop
   $ git commit -am "Release v<version>"
   $ git tag v<version>
   ```

2. **Pack it from a clean output folder**, so that a stale `.nupkg` can never be the one pushed. Then run the content checks and the [consumer smoke test](#consumer-smoke-test) against it:

   ```sh
   $ rm -rf artifacts/packages
   $ ./scripts/pack.sh -p:ContinuousIntegrationBuild=true
   ```

3. **Push `develop` with the tag**, and wait for CI to pass on the version commit:

   ```sh
   $ git push --follow-tags origin develop
   ```

4. **Fast-forward `master` to `develop`** and push it, so that `master` points at exactly the tagged commit:

   ```sh
   $ git switch master
   $ git pull --ff-only
   $ git merge --ff-only develop
   $ git push origin master
   ```

5. **Publish from `master`.** Re-pack on `master`. It is the same commit, but this guarantees the package's embedded commit is the tagged one. Then push. Keep the key in an environment variable, and never paste it into a committed file or a shell history you keep:

   ```sh
   $ rm -rf artifacts/packages
   $ ./scripts/pack.sh -p:ContinuousIntegrationBuild=true
   $ dotnet nuget push artifacts/packages/<PackageId>.<version>.nupkg \
       --api-key "$NUGET_API_KEY" \
       --source https://api.nuget.org/v3/index.json
   ```

   `dotnet nuget push` picks up the `.snupkg` next to the `.nupkg` automatically.

6. **Verify the release.** nuget.org validates and indexes a new version over several minutes. Once `curl -s https://api.nuget.org/v3-flatcontainer/<packageid>/index.json` lists it, re-run the [consumer smoke test](#consumer-smoke-test) with the `local` source removed from `nuget.config`, so the package comes from nuget.org. Check that the README renders on `https://www.nuget.org/packages/<PackageId>/<version>` with working links.

7. **Switch back to `develop`** to continue work:

   ```sh
   $ git switch develop
   ```
