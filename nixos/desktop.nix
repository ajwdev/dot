{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # wayland things
    wl-clipboard

    ffmpeg
    fuse
    kcalc
    vlc
    libdvdcss
    ffmpeg
    discord
    unstable.obsidian
    unstable.signal-desktop

    playerctl
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
    elisa
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

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # TODO I can't get these to work in the home manager file. I dont know why
  programs._1password = {
    enable = true;
    package = pkgs.unstable._1password;
  };
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "andrew" ];
    package = pkgs.unstable._1password-gui;
  };

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
