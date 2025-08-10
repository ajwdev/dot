{ inputs, outputs, lib, ... }:
{
  # XXX This is to address an error about an unexpected uid/gid numbers. I think I
  # just need to reinstall Nix, but that's for another day.
  ids.gids.nixbld = 350;

  users.users = {
    # XXX Hacky, but seems to work. Make this better
    "andrewwilliams" = {
      home = "/Users/andrewwilliams";
    };
    "andrew" = {
      home = "/Users/andrew";
    };
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
    # This is needed to use the Determinate systems install.
    enable = false;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = "auto";
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
