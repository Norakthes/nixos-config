# Desktop environment and GUI applications
{ config, pkgs, st, ... }:

{
  # X11 server
  services.xserver.enable = true;

  # Display manager with theme
  services.xserver.displayManager.lightdm = {
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
    arc-theme
    
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
    
    # Hardware acceleration
    mesa
  ];



  # Programs
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # XDG portals
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = "*";
      };
    };
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