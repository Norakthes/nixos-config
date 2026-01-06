{ config, pkgs, ... }:
{
  services.asusd = {
    enable = true;
    enableUserService = true;
    asusdConfig.text = ''

    '';
  };
}
