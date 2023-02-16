{
  description = "all of my configurations";
  inputs =
    {
      # Nixpkgs
      nixpkgs.follows = "nixpkgs-stable";
      nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";

      nixos-hardware.url = "github:nixos/nixos-hardware";

      nix-alien.url = "github:thiagokokada/nix-alien";

      flake-utils.url = "github:numtide/flake-utils";
      # Home manager
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      plasma-manager = {
        url = "github:pjones/plasma-manager";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
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
      # nur.url = "github:nix-community/NUR";

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

  outputs = { nixpkgs, nixpkgs-unstable, nixpkgs-stable, home-manager, nixos-hardware, nur, nix-on-droid, ... }@inputs:
    let

      # This instantiates nixpkgs for each system listed
      # Allowing you to configure it (e.g. allowUnfree)
      # Our configurations will use these instances
      legacyPackages = nixpkgs.lib.genAttrs [ "nixpkgs-stable" "nixpkgs-unstable" "nixpkgs" ]
        (channel:
          nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ] (system:
            import inputs.${channel} {
              inherit system;

              config.allowUnfree = true;
            }));



      specialArgs =
        nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ] (system:
          rec{
            inherit inputs; # Pass flake inputs to our config
            pkgs-s = legacyPackages.nixpkgs-stable.${system};
            pkgs-u = legacyPackages.nixpkgs-unstable.${system};

            # pkgs = pkgs-s;
            stateVersion = "22.05";

            inherit system;
          });
    in
    {
      nixosConfigurations = {
        lenovo-ideapad-510 = nixpkgs.lib.nixosSystem {
          specialArgs = specialArgs.x86_64-linux // {
            hardware = "lenovo-ideapad-510";
          };
          modules = [
            nur.nixosModules.nur
            # hyprland.nixosModules.default
            ./nixos/configuration.nix
          ];

        };
      };


      homeConfigurations = {
        "alper@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = legacyPackages.nixpkgs-stable.x86_64-linux;

          extraSpecialArgs = specialArgs.x86_64-linux;
          modules = [
            ./home-manager/home.nix
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];
        };
      };


      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        extraSpecialArgs = specialArgs.aarch64-linux;
        # _module.args = {
        #   inherit specialArgs;
        # } // specialArgs;
        modules = [ ./nix-on-droid/nix-on-droid.nix ];

        # modules = [
        #   (input: {
        #
        #     system.stateVersion = "22.05";
        #   })
        # ];
      };
    };
}
