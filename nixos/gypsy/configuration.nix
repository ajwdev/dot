{ inputs, modulesPath, ... }:
{
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-3
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    (import ../roles/audio-control.nix { hostname = "gypsy"; })
  ];

  # SD-image module handles partitioning; no hardware-configuration.nix needed.
  # To build: nix build .#nixosConfigurations.gypsy.config.system.build.sdImage
  # Flash:    zstdcat result/sd-image/*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress
  #
  # Prerequisites on the build host (tomservo):
  #   boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
