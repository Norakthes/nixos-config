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
      filesystems = [ "/" ];
    };
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  environment.systemPackages = with pkgs; [
    btrfs-progs
    compsize
  ];

  programs.zsh.shellAliases = {
    btrfs-usage = "sudo btrfs filesystem usage /";
    btrfs-show = "sudo btrfs filesystem show";
    btrfs-compress-check = "sudo compsize /";
    btrfs-defrag = "sudo btrfs filesystem defragment -r -v -czstd /";
  };
}
