{ config, pkgs, global_config, machine_name, ... }:
{
  imports = [
    ./home/git.nix
    ./home/nixvim.nix
  ];

  home = {
    username = global_config.username;
    homeDirectory = "/home/${global_config.username}";
    stateVersion = "25.05";

    file.".hm-test".text = ''
      Home manager is working
      Generated on: $(date)
      Machine: ${global_config.hostname}
      User: ${global_config.username}
    '';

    packages = with pkgs; [
      libreoffice
    ];
  };

  programs.home-manager.enable = true;
}
