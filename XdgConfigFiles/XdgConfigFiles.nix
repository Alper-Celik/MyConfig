{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-u,
  pkgs-s,
  specialArgs,
  my-lib,
  my-pkgs,
  ...
}:
let
  configs = builtins.removeAttrs (builtins.readDir ./.) [ "XdgConfigFiles.nix" ];
  current-dir = "XdgConfigFiles";
  outOfStrore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  xdg.configFile = builtins.mapAttrs (file: _: { source = outOfStrore file; }) configs;

  # Forked vim-zellij-navigator (niri-aware); zellij loads it by this path from
  # XdgConfigFiles/zellij/config.kdl.
  home.file.".local/share/zellij/plugins/vim-zellij-navigator.wasm".source =
    "${my-pkgs.zellij-navigator}/vim_zellij_navigator.wasm";
}
