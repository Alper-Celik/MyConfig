{ my-lib, hardware, ... }:
{
  imports = my-lib.getConfigs {
    removed-files = [
      "configs.home.nix"
      "configs.os.nix"
    ];
    suffixes = [
      ".os"
      ".os.${hardware}"
    ];
    base-dir = ./.;
  };
}
