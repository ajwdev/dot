{
  description = "My own Neovim flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";

    nil.url = "github:oxalica/nil";

    # Used for shell.nix
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      neovim-nightly,
      nil,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      outputs = flake-utils.lib.eachSystem systems (
        system:
        let
          overlayFlakeInputs = prev: final: { neovim = neovim-nightly.packages.${system}.neovim; };
          overlayMyNeovim = prev: final: { neovim = import ./default.nix { pkgs = final; }; };

          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              overlayFlakeInputs
              overlayMyNeovim
              nil.overlays.nil
            ];
          };
        in
        rec {
          stdenv = pkgs.clangStdenv;
          defaultPackage = pkgs.neovim;

          # "Apps" so that `nix run` works. If you run `nix run .` then
          # this will use the latest default.
          apps = {
            default = apps.myNeovim;
            myNeovim = flake-utils.lib.mkApp { drv = pkgs.neovim; };
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
          devShell = self.devShells.${system}.default;
        }
      );
    in
    outputs
    // {
      # Overlay that can be imported so you can access the packages
      # using zigpkgs.master or whatever you'd like.
      overlays.default = final: prev: { myneovim = outputs.packages.${prev.system}; };
    };

  #   in
  #   {
  #     packages.x86_64-linux.default = pkgs.myNeovim;
  #     apps.x86_64-linux.default = {
  #       type = "app";
  #       program = "${pkgs.myNeovim}/bin/nvim";
  #     };
  #   }
}
