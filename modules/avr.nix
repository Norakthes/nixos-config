# modules/avr.nix
{ config, pkgs, lib, global_config, ... }:
{
  environment.systemPackages = with pkgs; [
    # AVR toolchain
    pkgsCross.avr.buildPackages.gcc
    pkgsCross.avr.buildPackages.binutils
    pkgsCross.avr.buildPackages.gdb
    avrdude
    compiledb
    
    # Simulators and utilities
    simavr
    
    # Serial communication
    picocom
    minicom
    screen
  ];

  # Add user to dialout group for serial port access
  users.users.${global_config.username} = {
    extraGroups = [ "dialout" ];
  };

  # Udev rules for common AVR programmers
  services.udev.extraRules = ''
    # USBasp programmer
    SUBSYSTEM=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", MODE="0666"
    
    # USBtinyISP
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1781", ATTRS{idProduct}=="0c9f", MODE="0666"
    
    # Arduino as ISP
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2341", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2a03", MODE="0666"
    
    # Atmel/Microchip programmers (STK500v2, etc.)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", MODE="0666"
  '';
}
