{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NUR
    nur.url = "github:nix-community/NUR";

  };

  outputs = { nixpkgs, nixpkgs-stable, home-manager, nixos-hardware, nur, ... }@inputs: rec {
    # This instantiates nixpkgs for each system listed
    # Allowing you to configure it (e.g. allowUnfree)
    # Our configurations will use these instances
    legacyPackages = nixpkgs.lib.genAttrs [ "x86_64-linux" "x86_64-darwin" ] (system:
      import inputs.nixpkgs {
        inherit system;

        # NOTE: Using `nixpkgs.config` in your NixOS config won't work
        # Instead, you should set nixpkgs configs here
        # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)
        config.allowUnfree = true;
      }
    );



    legacyPackages-stable = nixpkgs-stable.lib.genAttrs [ "x86_64-linux" "x86_64-darwin" ] (system:
      import inputs.nixpkgs-stable {
        inherit system;

        # NOTE: Using `nixpkgs.config` in your NixOS config won't work
        # Instead, you should set nixpkgs configs here
        # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)
        config.allowUnfree = true;
      }
    );

    pkgs = legacyPackages.x86_64-linux;
    specialArgs = {
      inherit inputs; # Pass flake inputs to our config
      pkgs-s = legacyPackages-stable.x86_64-linux;
      pkgs-u = pkgs;
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

    # homeConfigurations = {
    #   # FIXME replace with your username@hostname
    #   "alper@nixos" = home-manager.lib.homeManagerConfiguration {
    #     pkgs = legacyPackages.x86_64-linux;
    #     extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
    #     # > Our main home-manager configuration file <
    #     modules = [ ./home-manager/home.nix ];
    #   };
    # };
  };
}
