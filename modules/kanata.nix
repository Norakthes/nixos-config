{ config, pkgs, global_config, ... }:
{
  boot.kernelModules = [ "uinput" ];
  hardware.uinput.enable = true;


  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="UINPUT", OPTIONS+="static_node=uinput"
  '';

  # Make sure the uinput group exists
  users.groups.uinput = { };


  systemd.services.kanata-internationalKeyboard.serviceConfig = {
     SupplementaryGroups = [
        "input"
	"uinput"
     ];
  };

  services.kanata = {
     enable = true;
     keyboards = {
        internalKeyboard = {
           devices = [
             global_config.keyboard
           ];
	   extraDefCfg = "process-unmapped-keys yes";
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
  };
}
