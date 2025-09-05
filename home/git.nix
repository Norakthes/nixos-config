{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Rasmus Bødker";
    userEmail = "rasmus.b.bodker@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";

      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
      };
    };
  };
}
