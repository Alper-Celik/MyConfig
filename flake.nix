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

    # NUR
    nur.url = "github:nix-community/NUR";

  };

  outputs = { nixpkgs, nixpkgs-unstable, nixpkgs-stable, home-manager, nixos-hardware, nur, ... }@inputs: rec {

    # This instantiates nixpkgs for each system listed
    # Allowing you to configure it (e.g. allowUnfree)
    # Our configurations will use these instances
    legacyPackages = nixpkgs.lib.genAttrs [ "nixpkgs-stable" "nixpkgs-unstable" "nixpkgs" ]
      (channel:
        nixpkgs.lib.genAttrs [ "x86_64-linux" "x86_64-darwin" ] (system:
          import inputs.${channel} {
            inherit system;

            config.allowUnfree = true;
          }));


    pkgs = legacyPackages.nixpkgs-stable.x86_64-linux;
    specialArgs = {
      inherit inputs; # Pass flake inputs to our config
      pkgs-s = legacyPackages.nixpkgs-stable.x86_64-linux;
      pkgs-u = legacyPackages.nixpkgs-unstable.x86_64-linux;
    };
    nixosConfigurations = {
      lenovo-ideapad-510 = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        specialArgs = specialArgs // {
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

        extraSpecialArgs = specialArgs;
        modules = [ ./home-manager/home.nix ];
      };
    };
  };
}
