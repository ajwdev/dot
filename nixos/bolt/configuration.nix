{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd

    ./hardware-configuration.nix

    ../common.nix
    ../users.nix
    ../desktop.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bolt";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # UDOO Bolt: AMD Ryzen Embedded V1605B (Zen) + Vega iGPU.
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics.enable = true;

  # Plasma6/SDDM/pipewire come from ../desktop.nix; don't restate them here.

  # This value determines the NixOS release from which the default settings for
  # stateful data were taken. Leave at the release of the first install.
  system.stateVersion = "25.05";
}
