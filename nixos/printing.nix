{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }:
{

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];
}
