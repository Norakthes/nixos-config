# X11 + LightDM + dwm. Session programs (status bar, compositor, apps) are in
# home-manager.
{ pkgs, inputs, ... }:
{
  services.xserver.enable = true;

  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk = {
      enable = true;
      theme = {
        package = pkgs.arc-theme;
        name = "Arc-Dark";
      };
    };
  };

  services.xserver.windowManager.dwm = {
    enable = true;
    package = inputs.dwm.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
  services.displayManager.defaultSession = "none+dwm";

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
