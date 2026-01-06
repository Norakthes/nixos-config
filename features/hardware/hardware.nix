# Hardware-specific configurations
{ config, pkgs, lib, global_config, ... }:

let
  hasFeature = feature: builtins.elem feature global_config.features;
in
{
  # ASUS laptop controls
  services.asusd = lib.mkIf (hasFeature "asusctl") {
    enable = true;
  };

  # Power management
  powerManagement = lib.mkIf (hasFeature "power_management") {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  # YubiKey support
  services.yubikey = lib.mkIf (hasFeature "yubikey") {
    enable = true;
  };
  hardware.u2f = lib.mkIf (hasFeature "yubikey") {
    enable = true;
  };

  # RISC-V 32-bit development
  environment.systemPackages = with pkgs; lib.optionals (hasFeature "riscv32-dev") [
    zig
  ];
}