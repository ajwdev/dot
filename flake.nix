# Based on https://github.com/Misterio77/nix-starter-configs

{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
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

    # ashell.url = "github:MalpenZibo/ashell";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      nix-darwin,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            outputs.overlays.additions
            outputs.overlays.modifications
            outputs.overlays.stable-packages
            outputs.overlays.my-neovim-env
            outputs.overlays.nil
            outputs.overlays.zls
            inputs.ghostty.overlays.default
            inputs.zig.overlays.default
          ];
        };

      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./nix/pkgs { inherit pkgs; }
      );
      # Devshell for bootstrapping
      # Accessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./shell.nix { inherit pkgs; }
      );

      # Formatter configuration for 'nix fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

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
              home-manager.extraSpecialArgs = { inherit inputs outputs; };
              home-manager.users.andrew = {
                imports = [ ./home-manager/home.nix ];
                devtools.enableAll = true;
                gui.enable = true;
              };
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
              home-manager.backupFileExtension = "bak";
              home-manager.extraSpecialArgs = {
                inherit inputs outputs;
              };
              home-manager.users.andrew = {
                imports = [ ./home-manager/home.nix ];
                gui.enable = true;
              };
            }
          ];
        };

        "glados01" = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./nixos/glados01/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.extraSpecialArgs = {
                inherit inputs outputs;
              };
              home-manager.users.andrew = {
                imports = [ ./home-manager/home.nix ];
                # glados01/02 use nixpkgs-stable; home-manager follows unstable.
                # useGlobalPkgs = true means pkgs are stable regardless, so this is safe.
                home.enableNixpkgsReleaseCheck = false;
              };
            }
          ];
        };

        "glados02" = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./nixos/glados02/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.extraSpecialArgs = {
                inherit inputs outputs;
              };
              home-manager.users.andrew = {
                imports = [ ./home-manager/home.nix ];
                home.enableNixpkgsReleaseCheck = false;
              };
            }
          ];
        };

        "ajwlive" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nixos/ajwlive/configuration.nix ];
        };

        "ajwlive-aarch64" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nixos/ajwlive/configuration.nix ];
        };

        # aarch64 NixOS VM running in UTM on MacBook Pro — remote Nix builder.
        # Use bridged networking in UTM so cambot is reachable from tomservo.
        "cambot" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./nixos/cambot/configuration.nix ];
        };

        # Headless aarch64 dev VM in UTM on the work MacBook Pro (M3).
        # Carries the home-manager work profile (work dotfiles + Go), no GUI.
        "workvm" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./nixos/workvm/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.extraSpecialArgs = { inherit inputs outputs; };
              home-manager.users.andrew = {
                imports = [ ./home-manager/home.nix ];
                dotfiles.work.enable = true;
                devtools.go.enable = true;
                # gui.enable stays false → headless
              };
            }
          ];
        };

        # Lean bootstrap of workvm — same base, no home-manager. Small enough to
        # install inside UTM's RAM-backed installer store. Install this first,
        # boot, then `nixos-rebuild switch --flake .#workvm` to layer on the
        # full home-manager dev environment (built on-disk, not in the RAM store).
        "workvm-base" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./nixos/workvm/configuration.nix ];
        };

        # Headless audio orchestration appliance — runs minidsp-rs server.
        # gypsy:    Raspberry Pi 3 (aarch64) — SD image target.
        # gypsy-vm: KVM guest (x86_64) — fast dev/test target.
        "gypsy" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./nixos/gypsy/configuration.nix ];
        };

        "gypsy-vm" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./nixos/gypsy-vm/configuration.nix ];
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
              home-manager.users.andrew = {
                imports = [ ./home-manager/home.nix ];
                gui.enable = true;
              };
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
                dotfiles.work.enable = true;
                gui.enable = true;
              };

            }
          ];
        };
      };

      homeConfigurations = {
        "andrew@tomservo" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home.nix
            {
              devtools.enableAll = true;
              gui.enable = true;
            }
          ];
        };

        "andrew@bender" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "x86_64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./home-manager/home.nix
            { gui.enable = true; }
          ];
        };

        # growler: Raspberry Pi 3B+ (aarch64), non-NixOS headless base.
        # Minimal by default — gui and devtools off. mkPkgs gives allowUnfree
        # (the base pulls claude-code); overlays are lazy so they cost nothing
        # unless referenced. Apply with:
        #   home-manager switch --flake .#andrew@growler
        "andrew@growler" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "aarch64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home-manager/home.nix ];
        };

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
              dotfiles.work.enable = true;
            }
          ];
        };
      };
    };
}
