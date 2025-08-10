{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  alacrittyTheme = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/aarowill/base16-alacritty/c9e824811eed70d7cdb1b31614b81c2f82bf16f8/colors/base16-eighties.toml";
    hash = "sha256-JuTdsi5VLA2HM5RH7+E/I/QCC7BlR1s4H0jGEYsAG00=";
  };
in
{
  # Disable broken mako module to prevent build errors
  disabledModules = [ "services/mako.nix" ];
  xdg.configFile."alacritty/alacritty.toml".source = ../dotfiles/alacritty/alacritty.toml;
  xdg.configFile."alacritty/base16-eighties.toml".source = alacrittyTheme;
  xdg.configFile."ghostty/config".source = ../dotfiles/ghostty/config;

  home.packages = with pkgs; [
    # TODO flake doesnt seem to work on macOS
    #ghostty

    yubikey-manager
  ];

  programs.alacritty.enable = true;
}
