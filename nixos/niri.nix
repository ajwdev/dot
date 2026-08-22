{ inputs, pkgs, lib, ... }:
{
  # niri-flake's module. It enables the niri.cachix.org binary cache and
  # disables the nixpkgs niri module to avoid conflicts. Trialing niri
  # alongside Hyprland — both sessions install and are selectable in SDDM.
  imports = [ inputs.niri.nixosModules.niri ];

  # Exposes pkgs.niri-stable / pkgs.niri-unstable.
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  # niri-flake enables gnome-keyring, which auto-enables gcr-ssh-agent and
  # conflicts with programs.ssh.startAgent (desktop.nix). Keep the existing
  # OpenSSH agent authoritative for both sessions.
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };

  environment.systemPackages = with pkgs; [
    # niri has no built-in XWayland; this bridges X11 clients.
    xwayland-satellite

    # Ecosystem replacements for the Hyprland-only daemons/tools. niri can't
    # run hypridle/hyprlock/hyprpaper/hyprlauncher.
    fuzzel # launcher (replaces hyprlauncher)
    swaylock # screen locker (replaces hyprlock)
    swayidle # idle daemon (replaces hypridle)
    swaybg # wallpaper (replaces hyprpaper)

    # Shared wayland tools are already installed via desktop.nix/hyprland.nix
    # (quickshell, dunst, copyq, grim/slurp/swappy, brightnessctl, wl-clipboard,
    # hyprpolkitagent) and are reused by the niri config.
  ];
}
