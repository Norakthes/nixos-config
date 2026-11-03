#!/usr/bin/env bash
# Evaluate every host in the flake. Used by CI, also fine to run locally.
set -euo pipefail

for host in $(nix eval --json .#nixosConfigurations --apply builtins.attrNames | jq -r '.[]'); do
  echo "::group::$host"
  nix eval --raw ".#nixosConfigurations.$host.config.system.build.toplevel.drvPath"
  echo
  echo "::endgroup::"
done
