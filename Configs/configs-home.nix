{ my-lib, ... }:
{
  imports = my-lib.getConfigs [ "configs-home.nix" "configs-os.nix" ] "-home.nix" ./.;
}
