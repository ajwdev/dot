# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # libbluray = pkgs.libbluray.override {
    #   withAACS = true;
    #   withBDplus = true;
    # };
    # vlc = pkgs.vlc.override { inherit libbluray; };
    # lutris-unwrapped = prev.lutris-unwrapped.overrideAttrs (oldAttrs: rec {
    #   inherit (oldAttrs) pname;
    #   version = "0.5.17";
    #   src = prev.fetchFromGitHub {
    #     owner = "lutris";
    #     repo = "lutris";
    #     # rev = "v${version}";
    #     rev = "v0.5.17";
    #     hash = "sha256-Tr5k5LU0s75+1B17oK8tlgA6SlS1SHyyLS6UBKadUmw=";
    #   };
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
