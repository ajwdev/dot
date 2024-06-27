{ pkgs, lib, ... }:
{
  hardware.rtl-sdr.enable = true;

  environment.systemPackages = with pkgs; [
    rtl-sdr
    rtl_433
    gqrx
  ];

  services.udev.packages = [
    pkgs.rtl-sdr
  ];
}
