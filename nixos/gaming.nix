{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wineWowPackages.waylandFull
    winetricks
    cabextract
    gamescope
    glxinfo
    lutris
    dosbox
    # ksp package manager for mods
    ckan
    protonup-qt
    vulkan-tools

    sunshine
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # See https://dee.underscore.world/blog/running-ksp-under-nixos/
    package = pkgs.steam.override {
      extraPkgs = (
        pkgs: [
          pkgs.corefonts
          pkgs.vistafonts
        ]
      );
    };
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # This was needed to troubleshoot a crash. Not sure its needed anymore
  # environment.variables = {
  #   AMD_DEBUG = "dcc";
  # };
}
