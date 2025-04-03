{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };

  # boot.supportedFilesystems = lib.mkForce [
  #   "vfat"
  #   "exfat"
  #   "ext"
  #   "xfs"
  #   "ntfs"
  #   "cifs"
  #   "nfs"
  #   "bcachefs"
  #   "btrfs"
  #   "f2fs"
  #   "erofs"
  #   "overlayfs"
  #   "squashfs"
  #   # TODO
  #   # "zfs"
  # ];

  boot.kernelParams = [
    "console=tty1"
    "console=ttyS0,115200"
  ];

  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ]; # to start at boot
    serviceConfig.Restart = "always"; # restart when session is closed
  };

  networking.hostName = "ajwlive";

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    git
    curl

    zsh
    antidote # zsh plugin manager
    tmux
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    fzf # A command-line fuzzy finder
    # networking tools
    iperf3
    ldns # replacement of `dig`, it provide the command `drill`
    ipcalc # it is a calculator for the IPv4/v6 addresses
    # system call monitoring
    lsof # list open files
    pv
    rsync
    screen
    gnused
    gnutar
    gawk
    lsof
    mtr
    dnsutils # `dig` + `nslookup`
    socat
    mbuffer
    nmap
    file
    which
    killall
    watch
    parallel
    cowsay
    tree
    glow

    setserial
  ];

  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    # curl https://github.com/ajwdev.keys
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtiwx2PF6SRFaQD8MxWh9u/qiOgkfrbskl1JRMu6syUrrMsV81FrB7yGQyhGxjg0+Ks3KHqT1PiUOKxZtgbDBcEGcgdtuORo+cvvWJZkVgxWc4sw7laERmkRx9uPgDPdzYMLqR3R51JCU1D7TyCIyb3mE1G5DrEjlkJnfQrDZd7XmW7mijKLiqE7NuTsKQWbSaSvXjINkzmTOW/+YIDWglCbrdBBOjaeDww7LdrHFE4JBBYgdQq0oudl62h4bjeen9Xp1fSkHnHwPvgoqkW5lS6Xut3yV9xjpWzE49QS/R9ADOkhgALZQqmbUUn2lphlf1GaJfHWP+cA7urmXHbITnDl/5SJxkQuefLO7UQDKlhwxPVVhX7RM+qUM4tSnIk6CnWfvnvBF5YR6lFMLvqiNS6gUaqnxD4XmvsMgz66/Fd9ZvtpaFYCD8ZvwJLQU4/0QHJLzaUYe+PIvx+uLLYGNPWExMKMFTJtbwltyJ4+BwbGpkCliVfaFtS8MRpamxcjU="
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfx9KV+peGIRBzkU2zvxpq0oRfg2UTNqYbxVIJL2I68QQbrHGTATJiKr3kYs6IYcqNpk8Ab4PkkzAwLDBgVaViAXdiIwBESEGMy7tG0MhoXOqoArLjbkCH6g8dJGupC4HCvw5o1pbfQhiAxwc0SmFKVOxBa86MoKNakJy/+tkZpsoSB/joVDEvLVfPth01gRh1J9ytTv+mLOJ2cusTRx4qp2yKhVDseY+WzcsHRMBpaMeIQ+W5AfcAqT1+F6yQl3L5Rxf+tEMeJbhGevwX4oGETui6w3IOvzQp9evXJ0osbYRA5qHeOtvFW88xijvSUhVmQ0i1UIjqTBiVSYN1QM/COZmV6Q03TwVSs6rCWux5PsNX/GiCeSskNrwdjxOajgCaftma7Iuv3RMeTxcSBnILEaOT8NUOHh5oScRVohJr5kcGpB4tqn93pXxnkzNsg9RBN8B7/SWuIg1BLCFtjRFO0qQRWpYWWqPX8HlvNELiugtrb3wvvmtNfXpsEkpF3vM="
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
