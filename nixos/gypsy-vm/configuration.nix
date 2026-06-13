{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
    (import ../roles/audio-control.nix { hostname = "gypsy-vm"; })
    ../power.nix
  ];

  # hardware-configuration.nix is generated on first boot:
  #   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
  # Commit it, then: sudo nixos-rebuild switch --flake .#gypsy-vm

  services.qemuGuest.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
