{config, pkgs, lib}:
{
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection = true;

  users.users.rasmus.extraGroups = [ "libvirtd" "wheel" ];

  programs.virt-manager.enable = true;
}
