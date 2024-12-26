{
  description = "My own Neovim flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    # Used for shell.nix
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil.url = "github:oxalica/nil";
    zls.url = "github:zigtools/zls";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      outputs = flake-utils.lib.eachSystem systems (
        system:
        let
          neovimOverlay = prev: final: { neovim = inputs.neovim-nightly.packages.${system}.neovim; };

          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              neovimOverlay
              inputs.nil.overlays.nil
              (final: prev: { zls = inputs.zls.packages.${prev.system}.zls; })
            ];
          };
        in
        rec {
          stdenv = pkgs.clangStdenv;
          packages = import ./default.nix { inherit pkgs; };

          # "Apps" so that `nix run` works. If you run `nix run .` then
          # this will use the latest default.
          apps = rec {
            default = apps.myNeovim;
            myNeovim = flake-utils.lib.mkApp { drv = packages.myNeovim; };
          };

          # nix fmt
          # formatter = pkgs.alejandra;

          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              curl
              jq
              clang
            ];
          };

          # For compatibility with older versions of the `nix` binary
          devShell = self.devShells.${system}.myNeovim;
        }
      );
    in
    outputs
    // {
      overlays.default = final: prev: { neovim = outputs.packages.${prev.system}.myNeovim; };
    };
}
