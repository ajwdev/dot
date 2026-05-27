{ ... }:
{
  services.nut = {
    enable = true;
    mode = "standalone";
    ups.cyberpower = {
      driver = "usbhid-ups";
      port = "auto";
      description = "CyberPower ST900U";
    };
    users.admin = {
      passwordFile = "/etc/nut/admin.passwd";
      instcmds = "ALL";
      actions = [ "set" ];
    };
    users.upsmon = {
      passwordFile = "/etc/nut/upsmon.passwd";
      upsmon = "master";
    };
  };
}
