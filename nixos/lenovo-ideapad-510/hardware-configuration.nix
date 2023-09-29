# hardware specific thinks for ideapad
{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }:

{
  imports =
    [
      ./nvidia.nix
    ];

}
