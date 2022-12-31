{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }:
{

  extraSpecialArgs = specialArgs;
  imports = [

    ("${inputs.home-manager}/nixos")
  ];

}
