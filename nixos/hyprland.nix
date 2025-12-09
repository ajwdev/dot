{ inputs, pkgs, ... }:
{
  imports = [inputs.hyprland.nixosModules.default];

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  environment.systemPackages = with pkgs; [
    # Default in hyprland, install for backup purposes
    kitty

    # 1st party hyprland tools
    hypridle
    hyprlauncher
    hyprlock
    hyprpaper
    hyprpicker
    hyprpolkitagent
    hyprsunset

    quickshell
    qt6.qtdeclarative # for qmlls


    hyprpanel
    waybar
    ashell
    dunst
    copyq
    brightnessctl
    swappy
    grim
    slurp
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
