{ my-lib, hardware, ... }:
{
  imports = my-lib.getConfigs {
    removed-files = [
      "configs.mac.nix"
    ];
    suffixes = [
      ".mac"
      ".mac.${hardware}"
    ];
    base-dir = ./.;
  };
}
