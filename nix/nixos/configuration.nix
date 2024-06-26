# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];



  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      inputs.neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # NOTE This is for ZFS specifically
      allowBroken = true;
      # allowUnfree = lib.mkForce true;
      # allowUnfreePredicate = (pkg: true);
    };
  };

  # TODO figure this out. Apparently related to obsidian
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
        # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
     };
    grub = {
       efiSupport = true;
       device = "nodev";
       useOSProber = true;
    };
  };

  boot.supportedFilesystems = [ "zfs" "nfs" ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  # TODO I couldn't get the amdgpu drivers to work with the "latest" ZFS
  # kernel. This still works though so :shrug:
  # boot.kernelPackages = pkgs.linuxPackages_6_5;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };

  services.zfs.autoSnapshot.enable = true;

  networking.hostName = "tomservo";
  networking.hostId = "3775b9a8"; # Needed for zfs/zpool ownership
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  services.udev.packages = [ pkgs.yubikey-personalization pkgs.rtl-sdr ];
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  #console = {
  #  #font = "Lat2-Terminus16";
  #  #keyMap = "us";
  #  useXkbConfig = true; # use xkbOptions in tty.
  #};

  services.fwupd.enable = true;

  # Enable a windowing system. This also applies to Wayland despite the name
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    # extraPackages = with pkgs; [
    #   amdvlk
    # ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

# For 32 bit applications 

  hardware.rtl-sdr.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;


  services.xserver.displayManager.defaultSession = "plasmawayland";
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
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
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };
  # rtkit is optional but recommended
  security.rtkit.enable = true;

  # Enable CUPS
  services.printing.enable = true;
  hardware.bluetooth.enable = true;

  environment.variables = rec {
    AMD_DEBUG = "dcc";
  };

  # List packages installed in system profile. To search, run:
    environment.systemPackages = with pkgs; [
      vim
      git
      wget
      curl
      nurl
      pv
      rsync
      screen
      gnused
      gnutar
      gawk
      lsof
      mtr
      dnsutils  # `dig` + `nslookup`
      socat
      nmap
      file
      which
      killall
      ethtool
      pciutils
      usbutils
      pulseaudio
      vulkan-tools
      pkg-config
      gcc
      parted # Also contains partprobe
      nfs-utils

      wineWowPackages.waylandFull
      winetricks
      gamescope
      # steam
      lutris
      # (lutris.override {
      #   extraPkgs = pkgs: [
      #     wget
      #   ];
      # })


      k3b
      kcalc
      cdrkit
      wl-clipboard

      neofetch
      gnupg

      # archives
      zip
      xz
      unzip
      p7zip
      zstd
      zlib

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor

      # productivity
      # hugo # static site generator
      # glow # markdown previewer in terminal

      # btop  # replacement of htop/nmon
      iotop # io monitoring
      iftop # network monitoring

      # system call monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      lsof # list open files

      # system tools
      sysstat
      lm_sensors # for `sensors` command

      vlc
      makemkv
      handbrake
      libdvdcss
      ffmpeg

      ghidra

      wofi
      eww

      brave
      obsidian
      discord
      dosbox
      ckan

      blender-hip

      fuse
      libguestfs
      virt-manager

      blackmagic

      wofi
      rtl-sdr
      rtl_433

      protonup-qt
      cabextract

      awscli
      aws-vault
    ];

  environment.enableDebugInfo = true;

  fonts.packages = with pkgs; [
    # noto-fonts
    # noto-fonts-cjk
    # noto-fonts-emoji
    # liberation_ttf
    fira-code
    fira-code-symbols
    # mplus-outline-fonts.githubRelease
    # dina-font
    # proggyfonts
    jetbrains-mono
    corefonts
    vistafonts
  ];

  programs.zsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "zfs";

  hardware.flipperzero.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andrew = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "andrew" "plugdev" "docker" "wheel" "video" "audio" "cdrom" "dialout" "networkmanager" "libvirtd" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      tmux
    ];
  };

  users.groups.andrew.gid = 1000;

  # TODO I can't get these to work in the home manager file. I dont know why
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["andrew"];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    package = pkgs.steam.override {
      extraPkgs = (pkgs: [ pkgs.corefonts pkgs.vistafonts ]);
    };
  };

  services.flatpak.enable = true;

  programs.ssh.startAgent = true;
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}