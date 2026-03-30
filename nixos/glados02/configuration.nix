{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    (import ../roles/spine-router.nix {
      hostname = "glados02";
      loopbackIP = "10.255.0.2";
      uplinkIP = "10.0.2.2";
      mgmtIP = "192.168.15.11";
    })
  ];
}
