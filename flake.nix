{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    dwm.url = "github:norakthes/dwm-flake";
  };

  outputs = { self, nixpkgs, nixos-hardware, dwm }:
  let
    machine_configs = {
      laptop = {
        hostname = "laptop";
        username = "rasmus";
        features = [
          "gaming"
         # "power_management"
        ];
        keyboard = [
          "/dev/input/by-id/usb-ASUSTeK_Computer_Inc._N-KEY_Device-if02-event-kbd"
          "/dev/input/by-id/usb-ASUSTeK_Computer_Inc._N-KEY_Device-event-if00"
        ];
        gpu = {
          amd_bus_id = "PCI:07:00:0";
          nvidia_bus_id = "PCI:01:00:0";
        };
        hardware_module = nixos-hardware.nixosModules.asus-zephyrus-ga503;
      };

      desktop = {
        hostname = "desktop";
        username = "rasmus";
        features = [
          "gaming"
        ];
        keyboard = [
          "/dev/input/by-id/usb-ROYUAN_Akko_Multi-modes_Keyboard-B-event-kbd"
	];
        gpu = {
          type = "amd";
        };
        hardware_module = null;
      };
    };

    mkSystem = machine_name: config:
      let
        featureModules = builtins.filter
          (path: builtins.pathExists path)
          (map (feature: ./modules + "/${feature}.nix") config.features);
      in
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          global_config = config;
          inherit dwm;
          machine_name = machine_name;
        };
        modules = [
          ./configuration.nix
          ./machines/${machine_name}/hardware-configuration.nix
        ] ++ featureModules
        ++ nixpkgs.lib.optionals (builtins.pathExists ./machines/${machine_name}/default.nix) [
          ./machines/${machine_name}/default.nix
        ] ++ nixpkgs.lib.optionals (config.hardware_module != null) [
          config.hardware_module
        ];
      };
      
  in {
    nixosConfigurations = builtins.mapAttrs mkSystem machine_configs;
  };
}
