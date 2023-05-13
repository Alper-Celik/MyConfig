{ inputs, lib, config, pkgs, specialArgs, ... }:
{

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];
}
