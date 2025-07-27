{ config, pkgs, dwm, ...}:
{
  services.xserver = {
    enable = true;
    windowManager.dwm = {
      enable = true;
      package = dwm.packages.${pkgs.system}.default;
    };
  };

  services.displayManager.defaultSession = "none+dwm";
}
