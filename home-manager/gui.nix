{ pkgs, ... }:
{
  # Disable broken mako module to prevent build errors
  disabledModules = [ "services/mako.nix" ];
  xdg.configFile."ghostty/config".source = ../dotfiles/ghostty/config;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # TODO flake doesnt seem to work on macOS
    #ghostty

    yubikey-manager
    nerd-fonts.jetbrains-mono
  ];
}
