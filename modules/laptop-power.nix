{ pkgs, ... }:
{
  powerManagement.enable = true;

  services.tlp.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandlePowerKey = "suspend";
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    acpi
    powertop
    upower
  ];
}
