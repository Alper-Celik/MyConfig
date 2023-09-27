{ my-lib, ... }:
{
  imports = my-lib.getConfigs { removed-files = [ "configs-home.nix" "configs-os.nix" ]; suffix = "-home.nix"; base-dir = ./.; };
}
