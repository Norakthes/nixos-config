# Imported by every host
{ pkgs, ... }:
{
  system.stateVersion = "25.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 4d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };
  services.xserver.xkb.layout = "dk";
  console.keyMap = "dk-latin1";

  users.users.rasmus = {
    isNormalUser = true;
    description = "Rasmus Bødker";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # User shell config is in home-manager, this only provides the login shell.
  # compinit and the prompt are left to home-manager's .zshrc.
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
    promptInit = "";
  };
  environment.pathsToLink = [ "/share/zsh" ];
  programs.command-not-found.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    nix-index
  ];

  fonts.packages = [ pkgs.nerd-fonts.liberation ];

  services.openssh.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    touchpad = {
      accelProfile = "flat";
      naturalScrolling = true;
      tapping = false;
    };
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Only tailnet traffic goes over Tailscale, DNS and routes stay as they are
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--accept-dns=false" "--accept-routes=false" ];
  };

  # Run unpatched binaries
  programs.nix-ld.enable = true;

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # Maple (installed via home-manager) reads its license from here
  environment.variables.MAPLE_LICENSE_FILE = "/etc/maple/license.dat";
}
