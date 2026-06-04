{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.minidsp ];

  services.udev.extraRules = ''
    ATTR{idVendor}=="2752", MODE="0660", GROUP="plugdev"
    ATTR{idVendor}=="04d8", ATTRS{idProduct}=="003f", MODE="0660", GROUP="plugdev"
  '';
}
