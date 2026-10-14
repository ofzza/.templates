#!/usr/bin/env bash
# Packs every packable project in the solution (IsPackable=true) into artifacts/packages.
# Usage: ./scripts/pack.sh [extra dotnet pack arguments, e.g. -p:Version=0.2.0]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dotnet pack "$root/Template.DotNet.slnx" -c Release -o "$root/artifacts/packages" "$@"
