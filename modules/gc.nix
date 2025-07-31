{ config, pkgs, ... }:
{
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 4d --keep 10";  # Keep 10 generations, delete older than 4 days
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
}
