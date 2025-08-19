{
  inputs,
  outputs,
  lib,
  ...
}:
{
  # This is needed to use the Determinate systems install.
  nix.enable = false;

  users.users = {
    # XXX Hacky, but seems to work. Make this better
    "andrewwilliams" = {
      home = "/Users/andrewwilliams";
    };
    "andrew" = {
      home = "/Users/andrew";
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  nixpkgs = {
    hostPlatform = lib.mkDefault "aarch64-darwin";
    config = {
      allowUnfree = true;
    };

    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      outputs.overlays.my-neovim-env
    ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
