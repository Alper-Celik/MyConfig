{
  lib,
  my-lib,
  hardware,
  ...
}@args:
{
  options.x-headless = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Gating flag for GUI-only home configuration. Set it on machines without a
      graphical session (nix-on-droid, servers): GUI modules gate themselves on
      `!config.x-headless`, so those hosts keep only the terminal/tooling bits.
    '';
  };

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
