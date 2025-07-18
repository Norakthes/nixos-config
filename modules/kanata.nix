{ config, pkgs, global_config, scripts, ... }:
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
     package = pkgs.kanata-with-cmd;
     keyboards = {
        internalKeyboard = {
           devices = global_config.keyboard;
	   extraDefCfg = ''
             process-unmapped-keys yes
             danger-enable-cmd yes
           '';
	   # TODO: Make it read from a file
           config = ''
	      (defsrc
	         caps esc lctl lmet
                 volu vold
	      )

	      (deflayer base
	         esc caps lctl lctl
                 (cmd ${scripts.changevolscript}/bin/changevol "+5%") (cmd ${scripts.changevolscript}/bin/changevol "+5%")
	      )
	   '';
	};
     };
  };
}
