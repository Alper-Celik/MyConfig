{ config, lib, pkgs, pkgs-u, pkgs-s, specialArgs, ... }:

{

  # Simply install just the packages
  environment.packages = import ../Programs/Cli/program-list.nix { inherit pkgs pkgs-u pkgs-s; };
  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "22.11";

  home-manager.extraSpecialArgs = specialArgs;
  home-manager.config = ../home-manager/home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;


  # Set up nix for flakes                                 
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = "Europe/Istanbul";
}
