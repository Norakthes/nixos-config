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
