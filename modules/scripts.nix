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
in
{
  environment.systemPackages = [ changevolscript ]; 

  # Export the scripts for other modules to import
  _module.args.scripts = { inherit changevolscript; };
}
