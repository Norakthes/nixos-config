# Core system configuration - always applied
{ config, pkgs, ... }:

{
  # Essential system packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    nix-index
  ];

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages (global setting)
  nixpkgs.config.allowUnfree = true;

  # System state version
  system.stateVersion = "25.05";
}