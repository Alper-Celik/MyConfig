{ my-lib, hardware, ... }@args:
{
  imports = my-lib.getConfigs {
    removed-files = [
      "configs.home.nix"
      "configs.os.nix"
    ];
    suffixes = [
      ".home"
      ".home.${hardware}"
    ];
    base-dir = ./.;
  };
}
