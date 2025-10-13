{ pkgs, lib, ... }:
{
  hardware.rtl-sdr.enable = true;

  environment.systemPackages = with pkgs; [
    stable.rtl-sdr
    stable.rtl_433
    # gqrx
  ];

  services.udev.packages = [
    pkgs.stable.rtl-sdr
  ];
}
