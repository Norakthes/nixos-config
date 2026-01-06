# Gaming configuration
{ config, pkgs, lib, global_config, ... }:

let
  # GPU driver detection
  gpuDrivers = 
    let
      hasNvidia = (global_config.gpu ? nvidia_bus_id) || (global_config.gpu ? type && global_config.gpu.type == "nvidia");
      hasAmd = (global_config.gpu ? amd_bus_id) || (global_config.gpu ? type && global_config.gpu.type == "amd");
      hasIntel = (global_config.gpu ? intel_bus_id);
    in
    (lib.optionals hasNvidia [ "nvidia" ]) ++
    (lib.optionals hasAmd [ "amd" ]) ++
    (lib.optionals hasIntel [ "modesetting" ]);

  hasFeature = feature: builtins.elem feature global_config.features;

in
{
  # GPU drivers
  services.xserver.videoDrivers = gpuDrivers;

  # NVIDIA configuration
  hardware.nvidia = lib.mkIf (builtins.elem "nvidia" gpuDrivers) {
    modesetting.enable = true;
    
    prime = lib.mkIf (hasFeature "nvidia_hybrid") {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = lib.mkIf (global_config.gpu ? intel_bus_id) global_config.gpu.intel_bus_id;
      amdgpuBusId = lib.mkIf (global_config.gpu ? amd_bus_id) global_config.gpu.amd_bus_id;
      nvidiaBusId = global_config.gpu.nvidia_bus_id;
    };
  };

  # Gaming programs
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  # Gaming packages
  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
    lutris
    bottles
    heroic
    gamescope
  ];
}