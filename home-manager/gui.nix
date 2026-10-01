{ lib, pkgs, ... }:
{
  # Disable broken mako module to prevent build errors
  disabledModules = [ "services/mako.nix" ];
  xdg.configFile."ghostty/config".text =
    builtins.readFile ../dotfiles/ghostty/config
    + lib.optionalString pkgs.stdenv.isDarwin (builtins.readFile ../dotfiles/ghostty/config.macos);

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # TODO flake doesnt seem to work on macOS
    #ghostty

    yubikey-manager
    nerd-fonts.jetbrains-mono
  ];
}
