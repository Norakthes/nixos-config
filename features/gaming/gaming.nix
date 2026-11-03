# Gaming configuration
{ config, pkgs, lib, global_config, ... }:

let
  gpu = global_config.gpu;

  hasNvidia = (gpu ? nvidia_bus_id) || ((gpu ? type) && gpu.type == "nvidia");
  hasAmd    = (gpu ? amd_bus_id)    || ((gpu ? type) && gpu.type == "amd");
  hasIntel  = (gpu ? intel_bus_id);

  gpuDrivers =
    lib.optionals hasNvidia [ "nvidia"      ] ++
    lib.optionals hasAmd    [ "amdgpu"      ] ++
    lib.optionals hasIntel  [ "modesetting" ];

  hasFeature = feature: builtins.elem feature global_config.features;

in
{
  services.xserver.videoDrivers = gpuDrivers;

  hardware.nvidia = lib.mkIf (builtins.elem "nvidia" gpuDrivers) {
    modesetting.enable = true;

    prime = lib.mkIf (hasFeature "nvidia_hybrid") {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId  = gpu.nvidia_bus_id;
      intelBusId   = if (gpu ? intel_bus_id) then gpu.intel_bus_id else null;
      amdgpuBusId  = if (gpu ? amd_bus_id)   then gpu.amd_bus_id   else null;
    };
  };

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
    lutris
    #bottles
    heroic
    gamescope
  ];
}
