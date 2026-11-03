# nixos-config

System config for my NixOS machines. Everything user-level (shell, editor,
apps, dwm session programs) is in the separate home-manager repo.

```
flake.nix         list of hosts
hosts/<host>/     imports + hardware + machine-specific settings
modules/*.nix     shared pieces (common.nix is imported by every host)
```

```sh
sudo nixos-rebuild switch --flake .    # picks the host by hostname
```

New machine: `hosts/<hostname>/` with `default.nix` and
`hardware-configuration.nix`, then add the name to `flake.nix`.
