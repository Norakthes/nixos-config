{ config, pkgs, lib, global_config, ...}:
let
  wallpaperCfg = global_config.wallpaper or { 
    enable = true;
    interval = "10min";
    sources = [ ../wallpapers ]; 
  };
in
{ 
  config = lib.mkIf wallpaperCfg.enable {
    assertions = [
      {
        assertion = wallpaperCfg.sources != [];
        message = "Wallpaper service is enabled but no sources are configured.";
      }
      {
        assertion = lib.elem pkgs.feh config.environment.systemPackages;
        message = "wallpaper.enable = true requires feh to be installed. Add 'pkgs.feh' to environment.systemPackages.";
      }
    ];

    systemd.user.services.wallpaper = {
      description = "Set random wallpaper";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.feh}/bin/feh --bg-scale --randomize ${lib.concatStringsSep " " (map toString wallpaperCfg.sources)}";
      };
    };
  
    systemd.user.timers.wallpaper = {
      description = "Change wallpaper periodically";
      wantedBy = [ "graphical-session.target" ];
      timerConfig = {
        OnStartupSec = "0";
        OnUnitActiveSec = wallpaperCfg.interval;
        Unit = "wallpaper.service";
      };
    };
  };
}
