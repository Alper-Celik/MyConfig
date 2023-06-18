{
  description = "all of my configurations";
  inputs =
    {
      # Nixpkgs
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";


      nixos-hardware.url = "github:nixos/nixos-hardware";

      flake-utils.url = "github:numtide/flake-utils";
      get-flake.url = "github:Alper-Celik/get-flake";

      # Home manager
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      plasma-manager = {
        url = "github:pjones/plasma-manager";
      };

      # nix on droid
      nix-on-droid = {
        url = "github:t184256/nix-on-droid/release-22.11";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
      };

      # nix index
      nix-index-database = {
        url = "github:Mic92/nix-index-database";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # debug info
      nixseparatedebuginfod.url = "github:Alper-Celik/nixseparatedebuginfod-without-gdb-etc";
      dwarffs = { url = "github:edolstra/dwarffs"; inputs.nixpkgs.follows = "nixpkgs"; };
      # NUR
      nur.url = "github:nix-community/NUR";

      hyprland.url = "github:hyprwm/Hyprland";

      # fish plugins
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

  # dont add nixpkgs to list might broke defined modules
  outputs = { nixpkgs, home-manager, get-flake, nixos-hardware, nur, nix-on-droid, ... }@inputs:
    let
      my-lib = import ./my-lib/my-lib.nix { inherit (nixpkgs) lib; };

      overlays = import ./Overlays/allOverlays.nix ++ [
        (get-flake ./Configs/Neovim).overlays.default
      ];
      overlay_module = ({ ... }:
        {
          nixpkgs.overlays = overlays;
        });

      caches = {
        substituters = [
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };

      # This instantiates nixpkgs for each system listed
      # Allowing you to configure it (e.g. allowUnfree)
      # Our configurations will use these instances
      legacyPackages = inputs.nixpkgs.lib.genAttrs [ "nixpkgs" ]
        (channel:
          inputs.nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ] (system:
            import inputs.${channel} {
              inherit system overlays;
              config.allowUnfree = true;
            }));



      specialArgs =
        inputs.nixpkgs.lib.genAttrs
          [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ]
          (system:
            {
              inherit inputs overlays system caches my-lib; # Pass flake inputs to config
              stateVersion = "22.11";

            });
    in
    {
      nixosConfigurations = {
        lenovo-ideapad-510 = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = specialArgs.x86_64-linux // {
            hardware = "lenovo-ideapad-510";
          };
          modules = [
            nur.nixosModules.nur
            ./nixos/configuration.nix
            inputs.nixseparatedebuginfod.nixosModules.default
            ({ ... }: { services.nixseparatedebuginfod.enable = true; })
            overlay_module
          ];
        };
      };


      homeConfigurations =
        let
          generic-args = specialArgs.x86_64-linux // {
            configDir = "/home/alper/MyConfig";
            hardware = "unknown";
          };

          generic-home = {
            pkgs = legacyPackages.nixpkgs.x86_64-linux;
            extraSpecialArgs = generic-args;
            modules = [
              ./home-manager/home.nix
              overlay_module
            ];
          };
        in
        {
          "alper" = home-manager.lib.homeManagerConfiguration generic-home;
          "alper@lenovo-ideapad-510" = home-manager.lib.homeManagerConfiguration (generic-home //
            { extraSpecialArgs = generic-args // { hardware = "lenovo-ideapad-510"; }; });
        };



      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        extraSpecialArgs = specialArgs.aarch64-linux // { isFlake = true; };

        modules = [
          ./nix-on-droid/nix-on-droid.nix
        ];
        pkgs = legacyPackages.nixpkgs.aarch64-linux;

      };
    };
}
