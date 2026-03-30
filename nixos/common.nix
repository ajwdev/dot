{
  inputs,
  outputs,
  pkgs,
  config,
  lib,
  ...
}:
{

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      outputs.overlays.my-neovim-env
      outputs.overlays.nil
      outputs.overlays.zls
      inputs.ghostty.overlays.default
      inputs.zig.overlays.default
    ];

    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
      download-buffer-size = 536870912;
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
    lm_sensors

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring

    # system tools
    sysstat

    ndisc6
  ];

  programs.mtr.enable = true;
}
