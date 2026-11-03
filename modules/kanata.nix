# Caps <-> Esc, Super -> Ctrl. Hosts set
# services.kanata.keyboards.main.devices to their keyboards.
{ pkgs, ... }:
{
  services.kanata = {
    enable = true;
    package = pkgs.kanata-with-cmd;
    keyboards.main = {
      extraDefCfg = ''
        process-unmapped-keys yes
        danger-enable-cmd yes
      '';
      config = ''
        (defsrc
          caps esc lctl lmet
        )

        (deflayer base
          esc caps lctl lctl
        )
      '';
    };
  };
}
