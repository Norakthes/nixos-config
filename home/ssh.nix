{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;

    matchBlocks."*" = {

      compression = true;
      serverAliveInterval = 60;
      serverAliveCountMax = 10;
    };

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };

      "hpc" = {
        hostname = "login1.gbar.dtu.dk";
        user = "s235765";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
  };
}
