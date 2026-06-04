# NixOS configuration for a headless audio orchestration appliance.
# Runs the minidsp-rs server so a miniDSP unit is reachable over TCP.
# Intended for Raspberry Pi 3 (aarch64) and KVM guests (x86_64).
#
# Usage:
#   imports = [
#     (import ../roles/audio-control.nix { hostname = "gypsy"; })
#   ];
{ hostname }:
{
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ../common.nix
    ../users.nix
    ../minidsp.nix
  ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # mDNS — makes the host reachable as <hostname>.local
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  networking.firewall.allowedTCPPorts = [
    5333 # minidsp-rs server
  ];

  systemd.services.minidsp = {
    description = "miniDSP control daemon (minidsp-rs)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.minidsp}/bin/minidsp server --bind 0.0.0.0:5333";
      Restart = "on-failure";
      DynamicUser = true;
      SupplementaryGroups = [ "plugdev" "audio" ];
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
    };
  };

  # TODO: GPIO amp triggers via /dev/gpiochip0 on Pi 3.
  # pkgs.libgpiod provides gpioset/gpioget for scripting; a proper systemd
  # service would watch minidsp state and toggle amp power accordingly.

  system.stateVersion = "25.11";
}
