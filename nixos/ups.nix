{ ... }:
{
  power.ups = {
    enable = true;
    mode = "standalone";
    ups.cyberpower = {
      driver = "usbhid-ups";
      port = "auto";
      description = "CyberPower ST900U";
    };
    users.admin = {
      passwordFile = "/etc/nut/admin.passwd";
      instcmds = [ "ALL" ];
      actions = [ "set" ];
    };
    users.upsmon = {
      passwordFile = "/etc/nut/upsmon.passwd";
      upsmon = "primary";
    };
    upsmon.monitor.cyberpower = {
      system = "cyberpower@localhost";
      user = "upsmon";
      powerValue = 1;
    };
  };
}
