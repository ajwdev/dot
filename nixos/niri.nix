{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  # niri-flake's module. It enables the niri.cachix.org binary cache and
  # disables the nixpkgs niri module to avoid conflicts. Trialing niri
  # alongside Hyprland — both sessions install and are selectable in SDDM.
  imports = [ inputs.niri.nixosModules.niri ];

  # niri-flake enables gnome-keyring, which auto-enables gcr-ssh-agent and
  # conflicts with programs.ssh.startAgent (desktop.nix). Keep the existing
  # OpenSSH agent authoritative for both sessions.
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

  programs.niri = {
    enable = true;
    # XXX niri-flake's niri-stable overlay depends on libdisplay-info_0_2 which
    # was removed from nixpkgs-unstable on 2026-08-04. Use nixpkgs's own niri
    # until niri-flake catches up.
    package = pkgs.niri;
  };

  # niri-flake routes the FileChooser portal to gnome (default=gnome;gtk), but
  # xdg-desktop-portal-gnome only delegates the file chooser to the GTK impl
  # over D-Bus, which fails here with "FileChooser call failed: The name is not
  # activatable". The visible symptom: GTK apps' Open/Save dialogs (e.g.
  # HandBrake's "Open Source") do nothing. Pin FileChooser to the GTK backend,
  # which implements it directly.
  # NB: xdg-desktop-portal uses the *first* niri-portals.conf it finds and does
  # not merge across directories. Writing this to /etc/xdg shadows the one niri-
  # flake ships in its package share dir, so we must also restate its default
  # (gnome;gtk) or we'd lose it for every other portal (Screenshot, ScreenCast).
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.niri = {
      default = [ "gnome" "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };

  environment.systemPackages = with pkgs; [
    # niri has no built-in XWayland; this bridges X11 clients.
    xwayland-satellite

    # Ecosystem replacements for the Hyprland-only daemons/tools. niri can't
    # run hypridle/hyprlock/hyprpaper/hyprlauncher.
    fuzzel # launcher (replaces hyprlauncher)
    swaylock-effects # screen locker with blur (replaces hyprlock)
    swayidle # idle daemon (replaces hypridle)
    swaybg # wallpaper (replaces hyprpaper)

    # Shared wayland tools are already installed via desktop.nix/hyprland.nix
    # (quickshell, dunst, copyq, grim/slurp/swappy, brightnessctl, wl-clipboard,
    # hyprpolkitagent) and are reused by the niri config.
  ];
}
