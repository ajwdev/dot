# This file defines overlays
{ inputs, ... }:
rec {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # XXX Skip direnv tests to avoid fish dependency (fish tests fail on macOS)
    direnv = prev.direnv.overrideAttrs (oldAttrs: {
      doCheck = false;
    });

    # libbluray = pkgs.libbluray.override {
    #   withAACS = true;
    #   withBDplus = true;
    # };
    # vlc = pkgs.vlc.override { inherit libbluray; };
    #
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

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  nil = inputs.nil.overlays.nil;
  zls = inputs.zls.overlays.zls;

  my-neovim-env = final: prev: {
    neovim = import ./my-neovim.nix {
      pkgs = final;
      nightlyNvim = inputs.neovim-nightly.packages.${final.stdenv.hostPlatform.system}.default;
    };
  };
}
