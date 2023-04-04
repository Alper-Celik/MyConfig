{
  description = "all of my configurations";
  inputs =
    {
      # Nixpkgs
      nixpkgs.url = "github:Alper-Celik/nixpkgs/nixos-unstable";


      nixos-hardware.url = "github:nixos/nixos-hardware";

      nvimplugins.url = "path:./Configs/Neovim";

      flake-utils.url = "github:numtide/flake-utils";
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
      # NUR
      nur.url = "github:nix-community/NUR";

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
  outputs = { home-manager, nixos-hardware, nur, nix-on-droid, ... }@inputs:
    let
      overlays = import ./Overlays/allOverlays.nix ++ [ inputs.nvimplugins.overlays.default ];
      overlay_module = { ... }:
        {
          nixpkgs.overlays = overlays;

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
            rec{
              inherit inputs overlays system; # Pass flake inputs to our config
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
            overlay_module
          ];
          check = false; # can speed up evlatioun about 5 seconds
        };
      };


      homeConfigurations = {
        "alper@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = legacyPackages.nixpkgs-stable.x86_64-linux;

          extraSpecialArgs = specialArgs.x86_64-linux;
          modules = [
            ./home-manager/home.nix
            inputs.plasma-manager.homeManagerModules.plasma-manager
            overlay_module
          ];
        };
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
