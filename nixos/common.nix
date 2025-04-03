{ inputs, outputs, pkgs, config, lib, ... }:
{

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.my-neovim-env

      # You can also add overlays exported from other flakes:
      inputs.ghostty.overlays.default
      inputs.zig.overlays.default
      # inputs.neovim-nightly-overlay.overlays.default

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
    };
  };

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
      trusted-users = [
        "root"
        "andrew"
        "@wheel"
      ];
      auto-optimise-store = true;
    };
  };

  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";

  services.fwupd.enable = true;

  programs.zsh.enable = true;

  programs.nix-ld = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    home-manager
    nix-index
    cachix
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor
    nurl

    vim
    git
    wget
    curl
    pv
    rsync
    screen
    gnused
    gnutar
    gawk
    lsof
    dnsutils # `dig` + `nslookup`
    socat
    nmap
    file
    which
    killall
    ethtool
    pciutils
    usbutils
    parted # Also contains partprobe

    gnupg

    # archives
    zip
    xz
    unzip
    p7zip
    zstd
    zlib

    htop
    # btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
  ];

  programs.mtr.enable = true;
}
