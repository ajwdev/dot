{ pkgs, ... }:
let
  pinPackage = (import ../nix/lib/pinPackage.nix { inherit pkgs; }).pinPackage;
in
{
  environment.systemPackages = with pkgs; [
    # wayland things
    wl-clipboard

    fuse
    kdePackages.kcalc
    discord
    obsidian
    signal-desktop

    playerctl
    # XXX Addresses regression with Opus 5.1 audio tracks. Rolls back to
    # version 3.0.20
    (pinPackage {
      name = "vlc";
      commit = "d2679dcbf1a032b0583915a8e3f9faffe936e9f1";
      sha256 = "sha256:04bsa03mhzjq3p7c32znrmg3wfc9njwm4wg7hdsn2kyb6qcjlj5m";
    })
    firefox
    brave
    google-chrome
    ghostty
  ];

  # Enable a windowing system. This also applies to Wayland despite the name
  services.xserver.enable = true;

  # Enable the Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.displayManager.defaultSession = "plasma";
  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa
    # gwenview
    # okular
    # oxygen
    # khelpcenter
  ];
  # We use KDE, but we still want to configure GTK app settings
  programs.dconf.enable = true;

  programs.hyprland = {
    enable = true;
  };

  # Enable sound with PipeWire below
  services.pulseaudio.enable = false;
  # rtkit is optional but recommended. Allows programs to request realtime
  # scheduling.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable CUPS
  services.printing.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # https://nixos.wiki/wiki/Fonts
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    jetbrains-mono
    corefonts
    vistafonts
  ];
  fonts.fontDir.enable = true;

  programs.firefox.enable = true;
  programs.usbtop.enable = true;
  programs.ssh.startAgent = true;
  programs.gnupg.agent = {
    enable = true;
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
