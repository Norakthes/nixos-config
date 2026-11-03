{
  description = "Rasmus' NixOS system config (user config lives in the home-manager repo)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dwm = {
      url = "github:norakthes/dwm-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... }@inputs:
  let
    mkHost = host: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./hosts/${host} ];
    };
  in
  {
    # sudo nixos-rebuild switch --flake .   (picks $(hostname))
    nixosConfigurations = nixpkgs.lib.genAttrs [ "laptop" "desktop" ] mkHost;
  };
}
