# DWM window manager configuration
{ config, pkgs, dwm, ... }:

{
  # Enable DWM as window manager
  services.xserver.windowManager.dwm = {
    enable = true;
    package = dwm.packages.${pkgs.system}.default;
  };

  # Set default session to DWM
  services.displayManager.defaultSession = "none+dwm";

  # DWM status bar service
  systemd.user.services.dwmstatus = {
    description = "dwm status bar";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.dwmstatus}/bin/dwmstatus";
      Restart = "on-failure";
      RestartSecs = "5s";
    };
  };
}