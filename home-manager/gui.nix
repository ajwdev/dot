{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Disable broken mako module to prevent build errors.
  # disabledModules is a top-level module key, so it can't be gated by mkIf;
  # disabling an unused module is harmless when gui is off.
  disabledModules = [ "services/mako.nix" ];

  options.gui.enable = lib.mkEnableOption "GUI programs, fonts, and desktop config";

  config = lib.mkIf config.gui.enable {
    xdg.configFile."ghostty/config".source = ../dotfiles/ghostty/config;

    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # TODO flake doesnt seem to work on macOS
      #ghostty

      yubikey-manager
      nerd-fonts.jetbrains-mono
    ];
  };
}
