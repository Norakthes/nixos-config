# Smartcard daemon, udev rules and YubiKey touch for sudo. Tools and
# gpg-agent are in home-manager.
{ pkgs, ... }:
let
  u2fMappings = pkgs.writeText "u2f-mappings" ''
    rasmus:e3WaK8GhcrmulbEZGLQonDBQTUOAAkwHIK40rPjwPjlggwU6BcxXmlxpLQEfyuKbQoPiRqA0/MSMHoWWWJXGHQ==,VF6EU2oZ1FwuDjBAwo6GP+a7wHA5OBeWbsX0xpZ/8z8NsY0pwtrllht57Fz+aEqKOT0nCed5HjDeK1iY7TeTvg==,es256,+presence
  '';
in
{
  services.pcscd.enable = true;

  services.udev.packages = with pkgs; [
    yubikey-personalization
    libu2f-host
  ];

  security.pam.u2f = {
    enable = true;
    control = "required";
    settings = {
      origin = "pam://yubi";
      authfile = u2fMappings;
      cue = true;
    };
  };
  security.pam.services.sudo.u2f.enable = true;
}
