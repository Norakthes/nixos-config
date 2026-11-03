# ASUS ROG Zephyrus G15 (GA503), AMD iGPU + NVIDIA dGPU
{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga503
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/gaming.nix
    ../../modules/kanata.nix
    ../../modules/laptop-power.nix
    ../../modules/yubikey.nix
    ../../modules/avr.nix
    ../../modules/vm.nix
  ];

  networking.hostName = "laptop";

  services.kanata.keyboards.main.devices = [
    "/dev/input/by-id/usb-ASUSTeK_Computer_Inc._N-KEY_Device-if02-event-kbd"
    "/dev/input/by-id/usb-ASUSTeK_Computer_Inc._N-KEY_Device-event-if00"
    "/dev/input/by-id/usb-_Akko_2.4G_Wireless_Keyboard-event-kbd"
  ];

  services.asusd.enable = true;

  fileSystems."/".options = [
    "compress=zstd:3"
    "noatime"
    "space_cache=v2"
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
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

  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    nvidiaSettings = true;

    # Render on the iGPU, run `nvidia-offload <cmd>` to use the dGPU.
    # Bus IDs come from `lspci | grep -Ei 'vga|3d'`.
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:7:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.graphics.extraPackages = with pkgs; [
    libva
    nvidia-vaapi-driver
    libva-vdpau-driver
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  programs.localsend.enable = true;
  services.cloudflare-warp.enable = true;
}
