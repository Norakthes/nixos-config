{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Rasmus Bødker";
        email = "rasmus.b.bodker@gmail.com";
      };

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
