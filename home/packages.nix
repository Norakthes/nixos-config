{ config, pkgs, global_config, machine_name, ... }:
{
  home = {
    packages = with pkgs; [
      libreoffice
      shellcheck
    ];
  };
}
