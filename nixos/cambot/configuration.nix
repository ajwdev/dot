{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
    ../common.nix
    ../users.nix
  ];

  # hardware-configuration.nix is generated on first boot inside UTM:
  #   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

  networking.hostName = "cambot";
  networking.networkmanager.enable = true;

  # mDNS — makes this host reachable as cambot.local from tomservo
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  # UTM uses VirtIO; use bridged networking so cambot is reachable from tomservo
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;

  time.timeZone = "America/Chicago";

  system.stateVersion = "25.11";
}
