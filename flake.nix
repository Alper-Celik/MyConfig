{
  description = "Your new nix config";
  inputs = {
    # Nixpkgs
    nixpkgs.follows = "nixpkgs-stable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix on droid
    nix-on-droid = {
      url = "github:t184256/nix-on-droid/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NUR
    nur.url = "github:nix-community/NUR";

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

            pkgs = pkgs-s;
          });
    in
    rec {

      inherit legacyPackages;

      nixosConfigurations = {
        lenovo-ideapad-510 = nixpkgs.lib.nixosSystem {
          specialArgs = specialArgs.x86_64-linux // {
            hardware = "lenovo-ideapad-510";
          };
          modules = [
            nur.nixosModules.nur
            ./nixos/configuration.nix
          ];

        };
      };


      homeConfigurations = {
        "alper@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = legacyPackages.nixpkgs-stable.x86_64-linux;
          # extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config

          extraSpecialArgs = specialArgs.x86_64-linux;
          modules = [ ./home-manager/home.nix ];
        };
      };


      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        extraSpecialArgs = specialArgs.aarch64-linux;
        # _module.args = {
        #   inherit specialArgs;
        # } // specialArgs;
        modules = [ ./nix-on-droid/nix-on-droid.nix ];
      };
    };
}
