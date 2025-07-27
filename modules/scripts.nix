{ pkgs, ... }:
let
  changevolscript = pkgs.writeShellApplication {
    name = "changevol";
    runtimeInputs = with pkgs; [ 
      pulseaudio
      gawk
      libnotify 
    ];
    text = builtins.readFile ../scripts/changevol.sh;
  };

  changebrightnessscript = pkgs.writeShellApplication {
    name = "changbrightness";
    runtimeInputs = with pkgs; [ 
      brightnessctl
      libnotify 
    ];
    text = builtins.readFile ../scripts/changebrightness.sh;
  };
in
{
  environment.systemPackages = [ 
    changevolscript 
    changebrightnessscript
  ]; 

  # Export the scripts for other modules to import
  _module.args.scripts = { 
    inherit changevolscript;
    inherit changebrightnessscript;
  };
}
