{ inputs, outputs, pkgs, lib, config, ... }:
{
  users.users.andrew = {
    name = "Andrew";
    home = "/Users/andrew";
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "aarch64-darwin";
    config = { allowUnfree = true; };
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
