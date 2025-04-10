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
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./dotfiles.nix
    ./devtools.nix
    ./gui.nix
  ];
  
  home = rec {
    username = lib.mkDefault "andrew";
    homeDirectory = lib.mkDefault (if pkgs.stdenv.isDarwin 
      then "/Users/${username.content}" 
      else "/home/${username.content}");
  };

  # TODO
  # https://codeberg.org/dnkl/fuzzel
  # https://github.com/hyprland-community/awesome-hyprland#runners-menus-and-application-launchers
  # https://github.com/jtheoof/swappy
  # https://github.com/end-4/dots-hyprland/tree/hybrid
  # https://github.com/saimoomedits/eww-widgets/tree/main
  # https://github.com/elkowar/eww
  # https://github.com/emersion/grim
  # https://github.com/emersion/slurp
  # https://tesseract-ocr.github.io/tessdoc/Installation.html
  # https://github.com/emersion/mako

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  # basic configuration of git, please change to your own
  # programs.git = {
  #   enable = true;
  #   userName = "Ryan Yin";
  #   userEmail = "xiaoyin_c@qq.com";
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    zsh
    zplug
    antidote # zsh plugin manager
    tmux
    neovim

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    fzf # A command-line fuzzy finder
    # networking tools
    iperf3
    ldns # replacement of `dig`, it provide the command `drill`
    ipcalc # it is a calculator for the IPv4/v6 addresses
    # system call monitoring
    lsof # list open files
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

    httpie

    # Dev
    gnumake
    openssl
    # https://github.com/mitchellh/zig-overlay/blob/d07b6a999f051b23ae7704f9d63a966b4b0284d1/flake.nix#L56-L60

    # TODO Linux specific
    # gdb
    # strace # system call monitoring
    # ltrace # library call monitoring

    (ruby.withPackages (ps: with ps; [ rugged pry ]))
  ];

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    # zsh.enable = true; # see note on other shells below
  };

  # programs.zsh.enable = true;
  # Enable home-manager and git
  programs.git.enable = true;
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
