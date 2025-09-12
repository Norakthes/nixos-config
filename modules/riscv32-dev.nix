# modules/riscv32-dev.nix
{ config, pkgs, lib, global_config, ... }:
let
  riscv32Pkgs = import pkgs.path {
    system = pkgs.stdenv.system;
    crossSystem = { 
      config = "riscv32-unknown-linux-gnu";
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    riscv32Pkgs.buildPackages.gcc
    riscv32Pkgs.buildPackages.binutils
    riscv32Pkgs.buildPackages.gdb
    
    # RISC-V simulators and emulators
    spike     # RISC-V ISA simulator
    qemu      # Includes RISC-V system and user mode emulation   
  ];
}
