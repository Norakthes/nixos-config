{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    global_config = {
      hostname = "laptop";
      username = "rasmus";
      features = {};
      keyboard = "/dev/input/by-id/usb-ASUSTeK_Computer_Inc._N-KEY_Device-if02-event-kbd";
    };
  in {
    nixosConfigurations.${global_config.hostname} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit global_config; };
      modules = [ ./configuration.nix ];
    };
  };
}
