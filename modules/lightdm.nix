{ config, pkgs, ...}:
{
  services.xserver = {
    enable = true;
    
    displayManager.lightdm = {
      enable = true;
      greeters.gtk = {
        enable = true;
        theme = {
          package = pkgs.arc-theme;
          name = "Arc-Dark";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    arc-theme
  ];
}
