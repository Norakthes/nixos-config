{ config, pkgs, lib, global_config, ...}:
{
  powerManagement.enable = true;
  services.tlp.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    acpi
    powertop
    upower
  ];

  services.logind = {
    lidSwitch = "suspend";
    powerKey = "suspend";
  };

}
