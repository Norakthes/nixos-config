{ config, pkgs, lib, global_config, ... }:
{
  fileSystems."/" = {
    options = [
      "compress=zstd:3"
      "noatime"
      "space_cache=v2"
    ];
  };

  services.btrfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  environment.systemPackages = with pkgs; [
    btrfs-progs
    compsize
    libva-utils
    vdpauinfo
    radeontop
  ];

  programs.zsh.shellAliases = {
    btrfs-usage = "sudo btrfs filesystem usage /";
    btrfs-show = "sudo btrfs filesystem show";
    btrfs-compress-check = "sudo compsize /";
    btrfs-defrag = "sudo btrfs filesystem defragment -r -v -czstd /";
  };

  # Hardware video acceleration for Firefox
  hardware.graphics.extraPackages = with pkgs; [
    mesa
    libva
    nvidia-vaapi-driver
    libva-vdpau-driver
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "radeonsi";  # For AMD iGPU (change to "nvidia" if using dGPU)
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    nvidiaSettings = true;
  };

  programs.localsend.enable = true;
}
