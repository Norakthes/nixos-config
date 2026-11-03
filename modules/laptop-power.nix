{ pkgs, ... }:
{
  powerManagement.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

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
