# User accounts and basic groups
{ config, pkgs, global_config, ... }:

{
  # Define user account
  users.users.${global_config.username} = {
    isNormalUser = true;
    description = "Rasmus Bødker";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
}