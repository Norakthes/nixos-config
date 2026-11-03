# Serial and USB programmer access for AVR work. The toolchain is in
# home-manager.
{ ... }:
{
  users.users.rasmus.extraGroups = [ "dialout" ];

  services.udev.extraRules = ''
    # USBasp
    SUBSYSTEM=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", MODE="0666"
    # USBtinyISP
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1781", ATTRS{idProduct}=="0c9f", MODE="0666"
    # Arduino as ISP
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2341", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2a03", MODE="0666"
    # Atmel/Microchip (STK500v2 etc.)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", MODE="0666"
  '';
}
