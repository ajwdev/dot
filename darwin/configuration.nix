{ inputs, outputs, pkgs, lib, config, ... }:
{
  users.users.andrew = {
    name = "andrew";
    home = "/Users/andrew";
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "aarch64-darwin";
    config = { allowUnfree = true; };

    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.my-neovim-env
    ];
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = "auto";
    };
  };

  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
