# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, pkgs, lib, config, ... }:
{
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    ./hardware-configuration.nix

    ../common.nix
    ../users.nix
    ../desktop.nix
    ../gaming.nix
    ../virt.nix
    ../sdr.nix
    ../power.nix
    ../_1password.nix
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      memtest86.enable = true;
      configurationLimit = 30;
    };
  };

  boot.supportedFilesystems = [
    "btrfs"
    "nfs"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  networking.hostName = "tomservo";
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Enable a windowing system. This also applies to Wayland despite the name
  # services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  hardware.flipperzero.enable = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    nfs-utils
    ghidra
    wofi
    # asg
    dpdk
    blackmagic
    saleae-logic

    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
    idevicerestore

    k3b
    cdrkit
    makemkv
    handbrake
    discord
    blender-hip
  ];

  environment.enableDebugInfo = true;
  virtualisation.docker.enable = true;
  services.flatpak.enable = true;

  services.usbmuxd.enable = true;

  programs.ryzen-monitor-ng.enable = true;
  programs.rog-control-center.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
