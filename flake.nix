{
  description = "all of my configurations";
  inputs = {
    # Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-parts.url = "github:hercules-ci/flake-parts";
    get-flake.url = "github:Alper-Celik/get-flake";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    jovian-NixOS.url = "github:Jovian-Experiments/Jovian-NixOS";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    MyConfigSecrets = {
      url = "git+ssh://git@github.com/Alper-Celik/MyConfigSecrets.git";
      flake = false;
    };

    stylix.url = "github:danth/stylix/release-24.11";
    nightfox-nvim = {
      url = "github:EdenEast/nightfox.nvim";
      flake = false;
    };

    impermanence.url = "github:nix-community/impermanence";

    # nix on droid
    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # nix index
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dwarffs = { url = "github:edolstra/dwarffs"; };
    # NUR
    nur.url = "github:nix-community/NUR";

    spacemacs-git = {
      url = "github:syl20bnr/spacemacs";
      flake = false;
    };

    fastfetch-theme = {
      url = "github:Alper-Celik/fastfetch-theme-backup";
      flake = false;
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # fish plugins
    tide-fish = {
      url = "github:IlanCosman/tide";
      flake = false;
    };
    fzf-fish = {
      url = "github:PatrickF1/fzf.fish";
      flake = false;
    };
    autopair-fish = {
      url = "github:jorgebucaran/autopair.fish";
      flake = false;
    };
    bang-bang-fish = {
      url = "github:oh-my-fish/plugin-bang-bang";
      flake = false;
    };

  };
  outputs = { self, flake-parts, get-flake, nixpkgs, home-manager, nix-on-droid
    , ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, ... }: {

      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { config, pkgs, system, ... }:
        let
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            inherit (self.my) overlays;
            config.allowUnfree = true;
          };

          pkgs-stable = import inputs.nixpkgs-stable {
            inherit system;
            inherit (self.my) overlays;
            config.allowUnfree = true;
          };

        in rec {

          packages = import ./my-pkgs/my-pkgs.nix {
            inherit pkgs;
            my-lib = self.lib;
          };

          _module.args.pkgs = pkgs-stable;
          # TODO: maybe use let in ?
          _module.args.my-specialArgs = {
            hardware = "unknown";
            my-lib = self.lib;
            my-pkgs = packages;
            inherit inputs system;
            inherit (self.my) stateVersion overlays caches;
            inherit pkgs-stable pkgs-unstable;

          };

        };

      flake = {

        lib = import ./my-lib/my-lib.nix {
          inherit (nixpkgs) lib;
        }; # no stablity guarantee

        nixosModules = {
          apply-my-overlays = { nixpkgs.overlays = self.my.overlays; };
          enable-nixseparatedebuginfod = {
            services.nixseparatedebuginfod.enable = true;
          };

          default-modules = {
            imports = [
              inputs.nur.modules.nixos.default
              inputs.impermanence.nixosModules.impermanence
              inputs.stylix.nixosModules.stylix
              # inputs.jovian-NixOS.nixosModules.default

              self.nixosModules.apply-my-overlays
              self.nixosModules.enable-nixseparatedebuginfod
              # inputs.dwarffs.nixosModules.dwarffs
            ];
          };
        };

        nixosConfigurations = {
          lenovo-ideapad-510 = withSystem "x86_64-linux"
            ({ my-specialArgs, ... }:
              nixpkgs.lib.nixosSystem {
                specialArgs = my-specialArgs // {

                  configDir = "/home/alper/MyConfig"; # TODO: abstract it ?
                  hardware = "lenovo-ideapad-510";
                };
                modules = [
                  self.nixosModules.default-modules
                  ./nixos/configuration.nix
                ];
              });

          strix-scar-17 = withSystem "x86_64-linux" ({ my-specialArgs, ... }:
            nixpkgs.lib.nixosSystem {
              specialArgs = my-specialArgs // {

                configDir = "/home/alper/MyConfig"; # TODO: abstract it ?
                hardware = "strix-scar-17";
              };
              modules =
                [ self.nixosModules.default-modules ./nixos/configuration.nix ];
            });
        };

        homeConfigurations = withSystem "x86_64-linux"
          ({ my-specialArgs, pkgs, ... }:
            let
              generic-args = my-specialArgs // {
                configDir = "/home/alper/MyConfig"; # TODO: abstract it ?
              };

              generic-home = {
                inherit pkgs;
                extraSpecialArgs = generic-args;
                modules = [
                  # inputs.stylix.homeManagerModules.stylix
                  ./home-manager/home.nix
                ];
              };
            in {
              "alper" = home-manager.lib.homeManagerConfiguration generic-home;
              "alper@lenovo-ideapad-510" =
                home-manager.lib.homeManagerConfiguration (generic-home // {
                  extraSpecialArgs = generic-args // {
                    hardware = "lenovo-ideapad-510";
                  };
                });
            });

        nixOnDroidConfigurations.default = withSystem "aarch64-linux"
          ({ my-specialArgs, pkgs, ... }:
            nix-on-droid.lib.nixOnDroidConfiguration {
              extraSpecialArgs = my-specialArgs // {
                configDir = "/data/data/com.termux.nix/files/home/MyConfig";
                isFlake = true;
              };

              modules = [ ./nix-on-droid/nix-on-droid.nix ];
              inherit pkgs;
            });

        ## nonstandard outputs
        my = {
          overlays = import ./Overlays/allOverlays.nix ++ [
            # (get-flake ./Configs/Neovim).overlays.default
          ];

          caches = {
            substituters = [
              "https://nix-community.cachix.org"
              "https://cuda-maintainers.cachix.org"
            ];
            trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
            ];
          };

          stateVersion = "22.11";
        };

      };

    });
}
