{ inputs, lib, my-lib, config, pkgs, specialArgs, ... }:
{
  imports = my-lib.getConfigs [ "configs-home.nix" ] "-home.nix" ./.;
}
