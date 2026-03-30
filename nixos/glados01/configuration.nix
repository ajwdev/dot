{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    (import ../roles/spine-router.nix {
      hostname = "glados01";
      loopbackIP = "10.255.0.1";
      uplinkIP = "10.0.2.1";
      mgmtIP = "192.168.15.10";
    })
  ];
}
