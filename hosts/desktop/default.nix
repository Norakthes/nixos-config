{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/gaming.nix
    ../../modules/kanata.nix
  ];

  networking.hostName = "desktop";

  services.kanata.keyboards.main.devices = [
    "/dev/input/by-id/usb-ROYUAN_Akko_Multi-modes_Keyboard-B-event-kbd"
  ];

  services.xserver.videoDrivers = [ "amdgpu" ];

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
      ${pkgs.xrandr}/bin/xrandr \
        --output DP-3   --mode 1920x1080 --rate 60  --pos 0x249 \
        --output DP-1   --mode 2560x1440 --rate 165 --pos 1920x0 --primary \
        --output HDMI-1 --mode 1920x1080 --rate 60  --pos 4480x326
    ''}
  '';
}
