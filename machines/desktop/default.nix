{ config, pkgs, lib, global_config, ... }:
{
  fileSystems."/mnt/gamedisk" = {
    device = "/dev/disk/by-uuid/F28242238241ECA3";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "user"
      "exec"
      "uid=1000"
      "gid=100"
      "umask=000"
    ];
  }; 

  services.xserver.displayManager.lightdm.extraConfig = ''
    [Seat:*]
    position=50%,center
    display-setup-script=${pkgs.writeScript "lightdm-display-setup" ''
      #!${pkgs.bash}/bin/bash

      ${pkgs.xorg.xrandr}/bin/xrandr \
        --output DP-3   --mode 1920x1080 --rate 60  --pos 0x0 \
        --output DP-1   --mode 2560x1440 --rate 165 --pos 1920x0 --primary \
        --output HDMI-1 --mode 1920x1080 --rate 60  --pos 4480x0
    ''}
  '';
}
