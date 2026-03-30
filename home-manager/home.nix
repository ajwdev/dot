# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./config.nix
    ./dotfiles.nix
    ./devtools.nix
    ./gui.nix
  ];

  home.username = lib.mkDefault "andrew";
  home.homeDirectory = lib.mkDefault (
    if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}"
  );

  # Fix menu bar visibility in Hyprland
  home.sessionVariables = {
    # For GTK apps
    GTK_SHELL_SHOWS_MENUBAR = "0";
    GTK_SHELL_SHOWS_APP_MENU = "0";
  }
  // lib.optionalAttrs pkgs.stdenv.isLinux {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  # Packages that should be installed to the user profile.
  home.packages =
    with pkgs;
    [
      comma
      zsh
      antidote # zsh plugin manager
      tmux
      neovim
      nixfmt

      # utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      fzf # A command-line fuzzy finder
      # networking tools
      iperf3
      ldns # replacement of `dig`, it provide the command `drill`
      ipcalc # it is a calculator for the IPv4/v6 addresses
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
      mtr
      dnsutils # `dig` + `nslookup`
      socat
      nmap
      file
      which
      killall
      watch
      parallel
      tio
      minicom

      # misc
      cowsay
      tree
      glow

      claude-code

      # Dev
      openssl
      # https://github.com/mitchellh/zig-overlay/blob/d07b6a999f051b23ae7704f9d63a966b4b0284d1/flake.nix#L56-L60

      # TODO Linux specific
      # gdb
      # strace # system call monitoring
      # ltrace # library call monitoring

      (ruby.withPackages (
        ps: with ps; [
          rugged
          pry
          rake
        ]
      ))
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      # Qt theme configuration tools for menu bar fix (Wayland only)
      libsForQt5.qt5ct
      kdePackages.qt6ct
    ];

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      enableFishIntegration = false;
      nix-direnv.enable = true;
    };

    # zsh.enable = true; # see note on other shells below
  };

  # programs.zsh.enable = true;
  # Enable home-manager and git
  programs.git = {
    enable = true;
    signing.format = null;
  };
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = lib.mkIf pkgs.stdenv.isLinux "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
