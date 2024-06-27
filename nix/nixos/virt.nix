{ pkgs, lib, ... }:
{
  virtualisation.vswitch.enable = true; # open vswitch
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  # Allow all network bridges. Fine for my desktop
  environment.etc."qemu/bridge.conf".text = lib.mkForce ''
    allow all
  '';

  environment.systemPackages = with pkgs; [
    libguestfs
    tunctl
  ];
}
