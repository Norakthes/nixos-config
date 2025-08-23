{ config, pkgs, lib, global_config, ... }:
let
  u2fMappings = pkgs.writeText "u2f-mappings" ''
    ${global_config.username}:e3WaK8GhcrmulbEZGLQonDBQTUOAAkwHIK40rPjwPjlggwU6BcxXmlxpLQEfyuKbQoPiRqA0/MSMHoWWWJXGHQ==,VF6EU2oZ1FwuDjBAwo6GP+a7wHA5OBeWbsX0xpZ/8z8NsY0pwtrllht57Fz+aEqKOT0nCed5HjDeK1iY7TeTvg==,es256,+presence
  '';
in
{
  # Core YubiKey support
  services.pcscd.enable = true;
  
  # udev rules for YubiKey detection
  services.udev.packages = [ 
    pkgs.yubikey-personalization 
    pkgs.libu2f-host
  ];
  
  # Add YubiKey tools
  environment.systemPackages = with pkgs; [
    # Management tools
    yubikey-manager
    yubioath-flutter
    yubikey-personalization
    
    # For FIDO2/WebAuthn
    libu2f-host
    libfido2
    pcsclite

    gnupg
    pinentry-gtk2
    #pinentry-dmenu
    
    # Optional: for age encryption with YubiKey
    age-plugin-yubikey
  ];
  
  # GPG agent configuration for YubiKey
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    #pinentryPackage = pkgs.pinentry-dmenu;
    settings = {
      default-cache-ttl = 30; # 30 seconds
      max-cache-ttl = 60;     # 60 seconds
    };
  };

  environment.interactiveShellInit = ''
    export GPG_TTY=$(tty)
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  security.pam.u2f = {
    enable = true;
    settings = {
      origin = "pam://yubi";
      authfile = u2fMappings;
      cue = true;
    };
    control = "required";
  };

  security.pam.services = {
    sudo.u2fAuth = true;
  };

  systemd.user.services.yubikey-touch-detector = {
    description = "YubiKey touch detector";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      # The service needs the package, but NixOS handles it
      ExecStart = "${pkgs.yubikey-touch-detector}/bin/yubikey-touch-detector --libnotify";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    path = [ pkgs.gnupg ];
  };
}
