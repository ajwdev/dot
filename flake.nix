# Based on https://github.com/Misterio77/nix-starter-configs

{
  description = "Your new nix config";

  inputs = {
    nixos.url = "github:NixOS/nix";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # Also see the 'stable-packages' overlay at 'overlays/default.nix'.
    hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # TODO Look into using these to cleanup
    # flake-utils.url = "github:numtide/flake-utils";
    # flake-compat = {
    #   url = "github:edolstra/flake-compat";
    #   flake = false;
    # };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      # XXX Neovim nightly cannot follow stable, though I'm not sure this is
      # right either. Just comment out for now
      # https://github.com/nix-community/neovim-nightly-overlay/issues/616
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    ghostty.url = "github:ghostty-org/ghostty";
    zig.url = "github:mitchellh/zig-overlay";
    nil.url = "github:oxalica/nil";
    zls.url = "github:zigtools/zls";

    # TODO https://stylix.danth.me/installation.html
    # stylix.url = "github:danth/stylix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      nixos,
      nix-darwin,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in
    {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./nix/pkgs { inherit pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./shell.nix { inherit pkgs; }
      );

      # Formatter configuration for 'nix fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./nix/overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./nix/modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./nix/modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        "tomservo" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            # > Our main nixos configuration file <
            ./nixos/tomservo/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.extraSpecialArgs = {
                inherit inputs outputs;
                devtools.enable_all = true;
              };
              home-manager.users.andrew = import ./home-manager/home.nix;
            }
          ];
        };

        "bender" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./nixos/bender/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs outputs;
              };
              home-manager.users.andrew = import ./home-manager/home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };

        "glados01" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./nixos/glados01/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs outputs;
              };
              home-manager.users.andrew = import ./home-manager/home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };

        "ajwlive" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          packages.x86_64-linux.default = self.nixosConfigurations.exampleIso.config.system.build.isoImage;
          modules = [
            ./nixos/ajwlive/configuration.nix
            # ({ pkgs, modulesPath, ... }: {
            #   imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
            #   environment.systemPackages = [ pkgs.neovim ];
            # })
          ];
        };
      };

      darwinConfigurations = {
        "crow" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./darwin/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs outputs;
              };
              home-manager.backupFileExtension = "bak";
              users.users.andrew = {
                name = nixpkgs.lib.mkForce "andrew";
              };
              home-manager.users.andrew = import ./home-manager/home.nix;
            }
          ];
        };

        "work" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./darwin/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs outputs;
                devtools.go.enable = true;
              };
              home-manager.backupFileExtension = "bak";
              users.users.andrewwilliams = {
                name = nixpkgs.lib.mkForce "andrewwilliams";
              };
              home-manager.users.andrewwilliams = {
                imports = [ ./home-manager/home.nix ];
                # Work system overrides
                dotfiles.user.email = nixpkgs.lib.mkForce "andrewwilliams@netflix.com";
              };

            }
          ];
        };
      };

      homeConfigurations = {
        "coder" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            (
              { pkgs, ... }:
              {
                nixpkgs = {
                  overlays = [
                    outputs.overlays.additions
                    outputs.overlays.modifications
                    outputs.overlays.stable-packages
                    outputs.overlays.my-neovim-env
                  ];

                  config = {
                    allowUnfree = true;
                  };
                };

                home.username = pkgs.lib.mkForce "andrewwilliams";
                # We always this home directory for whatever reason :shrug:
                home.homeDirectory = pkgs.lib.mkForce "/home/coder";

                devtools.go.enable = true;
              }
            )
            {
              imports = [ ./home-manager/home.nix ];
              # Coder (work) system overrides
              dotfiles.user.email = nixpkgs.lib.mkForce "andrewwilliams@netflix.com";
            }
          ];
        };
      };
    };
}
