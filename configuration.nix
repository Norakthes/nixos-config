# Clean, modular configuration.nix
{ config, pkgs, lib, global_config, machine_name, st, ... }:

let
  hasFeature = feature: builtins.elem feature global_config.features;
  
  # Feature modules to load
  featureModules = builtins.filter
    (path: builtins.pathExists path)
    (map (feature: ./features + "/${feature}.nix") global_config.features);

  # Sub-feature modules (nested directories)
  subFeatureModules = builtins.filter
    (path: builtins.pathExists path)
    [
      ./features/desktop/desktop.nix
      ./features/desktop/dwm.nix
      ./features/development/development.nix
      ./features/gaming/gaming.nix
      ./features/hardware/hardware.nix
    ];

in
{
  imports = [
    # Core system modules (always applied)
    ./core/base.nix
    ./core/boot.nix
    ./core/networking.nix
    ./core/users.nix
    ./core/security.nix

    # Essential system modules
    ./modules/gc.nix
    ./modules/kanata.nix
    ./modules/scripts.nix
    ./modules/zsh.nix
    ./modules/wallpaper.nix
  ] ++ 
  # Load feature modules based on machine configuration
  (lib.optionals (hasFeature "desktop") [ ./features/desktop/desktop.nix ]) ++
  (lib.optionals (hasFeature "dwm") [ ./features/desktop/dwm.nix ]) ++
  (lib.optionals (hasFeature "development") [ ./features/development/development.nix ]) ++
  (lib.optionals (hasFeature "gaming") [ ./features/gaming/gaming.nix ]) ++
  (lib.optionals (hasFeature "asusctl" || hasFeature "power_management" || hasFeature "yubikey" || hasFeature "riscv32-dev") [ ./features/hardware/hardware.nix ]) ++
  # Machine-specific configuration
  (lib.optionals (builtins.pathExists ./machines/${machine_name}/default.nix) [
    ./machines/${machine_name}/default.nix
  ]);

  # Set hostname from machine config
  networking.hostName = global_config.hostname;

  # Custom packages overlay
  nixpkgs.overlays = [
    (final: prev: {
      dwmstatus = final.callPackage ./packages/dwmstatus {};
      maple = final.callPackage ./packages/maple {};
    })
  ];

  # Environment variables
  environment.variables = {
    MAPLE_LICENSE_FILE = "/etc/maple/license.dat";
  };

  # Flatpak support
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # Neovim
  programs.neovim.enable = true;
}