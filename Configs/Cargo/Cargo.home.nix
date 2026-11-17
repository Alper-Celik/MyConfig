{
  config,
  pkgs,
  specialArgs,
  my-lib,
  ...
}:
let
  current-dir = "Configs/Cargo";
  outOfStore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  home.packages = with pkgs; [
    mold # ld.mold, used by the global cargo config below
  ];

  # A live symlink, so linker/linker-flag changes apply to every cargo build
  # without a rebuild (same pattern as the Neovim config).
  home.file.".cargo/config.toml".source = outOfStore "config.toml";
}
