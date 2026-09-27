{
  pkgs,
  pkgs-unstable,
  lib,
  my-lib,
  specialArgs,
  config,
  ...
}:
let
  current-dir = "Configs/Vscode";
  outOfStore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  home.packages = lib.mkIf (!config.x-headless) (
    with pkgs;
    [
      (pkgs.python3.withPackages (p: [ p.pyside6 ]))
      fzf
      ripgrep
      bat
    ]
  );

  programs.vscode = lib.mkIf (!config.x-headless) {
    enable = true;
    package = pkgs-unstable.vscode;
  };

  xdg.configFile.nvim-vscode = lib.mkIf (!config.x-headless) {
    source = outOfStore ".";
  };
}
