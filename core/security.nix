# Security and services configuration
{ config, pkgs, ... }:

{
  # Enable SSH
  services.openssh.enable = true;

  # Audio (PipeWire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Input devices
  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
    };
    touchpad = {
      accelProfile = "flat";
      naturalScrolling = true;
      tapping = false;
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Nix-ld for running unpackaged binaries
  programs.nix-ld.enable = true;
}