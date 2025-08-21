{ config, pkgs, lib, global_config, ...}:
{
  powerManagement.enable = true;
  
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVENOR_ON_AC = "powersave";
      CPU_SCALING_GOVENOR_ON_BAT = "powersave";
    };
  };

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
