{ pkgs, config, lib, inputs, ... }:
{
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };

  i18n.defaultLocale = "en_US.UTF-8";

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
    nixfmt-rfc-style
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
    lm_sensors # for `sensors` command
  ];

  programs.mtr.enable = true;
}
