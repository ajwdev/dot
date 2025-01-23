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
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      #outputs.overlays.ghostty

      inputs.myneovim.overlays.default

      # You can also add overlays exported from other flakes:
      # inputs.neovim-nightly-overlay.overlays.default

      #inputs.zig.overlays.default

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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "andrewwilliams";
    homeDirectory = "/home/coder";
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

  # TODO I like this idea, but the deriavation is readonly and that breaks
  # zplug :/
  # home.file.".zplug".source = pkgs.fetchFromGitHub {
  #    owner = "zplug";
  #    repo = "zplug";
  #    rev = "ac6c2a3e9eea6a488d96d98c752ef887e7d5aae3";
  #    sha256 = "tvFHPCTL3JLGzT4DNVm6AAS9Bot7MClM/g3l4KwoXJo=";
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    zsh
    zplug
    tmux
    neovim

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    fzf # A command-line fuzzy finder
    # networking tools
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
    dnsutils # `dig` + `nslookup`
    socat
    nmap
    file
    which
    killall

    # misc
    cowsay
    tree
    glow
    bat

    httpie

    # Dev
    gnumake
    gdb
    openssl
    # https://github.com/mitchellh/zig-overlay/blob/d07b6a999f051b23ae7704f9d63a966b4b0284d1/flake.nix#L56-L60
    #zigpkgs.master
    # Rust
    #rustup
    # golang
    #go
    #gopls
    kubectl
    # gotools
    #go-tools
    # gomod2nix.packages.${system}.default

    # ruby
    #unstable.arduino-ide
    #unstable.arduino-cli

    unstable.tree-sitter

    #ghostty
  ];

  programs.rbenv.enable = true;
  # programs.java = {enable = true; package = pkgs.zulu17; };  

  #programs.alacritty.enable = true;

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
