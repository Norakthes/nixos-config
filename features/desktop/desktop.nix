# Desktop environment and GUI applications
{ config, pkgs, ... }:

{
  # Graphics
  hardware.graphics.enable = true;

  # X11 server
  services.xserver.enable = true;

  # Display manager with theme
  services.displayManager.lightdm = {
    enable = true;
    greeters.gtk = {
      enable = true;
      theme = {
        package = pkgs.arc-theme;
        name = "Arc-Dark";
      };
    };
  };

  # Desktop environment packages
  environment.systemPackages = with pkgs; [
    # Core GUI
    firefox
    dmenu
    j4-dmenu-desktop
    xorg.xev
    
    # File management
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    services.gvfs.enable = true;
    services.tumbler.enable = true;
    
    # Utilities
    brightnessctl
    feh
    xclip
    flameshot
    
    # Notifications
    dunst
    libnotify
    
    # File sharing
    transmission_4-gtk
    
    # Media
    ffmpeg-full
    ffmpegthumbnailer
  ];

  # Programs
  programs.thunar.enable = true;
  programs.xfconf.enable = true;

  # XDG portals
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Compositor
  services.picom = {
    enable = true;
    vSync = true;
  };

  # Redshift/Gammastep for blue light filtering
  services.redshift = {
    enable = true;
    package = pkgs.gammastep;
  };
  location = {
    provider = "manual";
    latitude = 55.68;
    longitude = 12.57;
  };
}