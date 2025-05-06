{
  pkgs,
  pkgs-unstable,
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
  home.packages = with pkgs; [
    (pkgs.python3.withPackages (p: [ p.pyside6 ]))
    fzf
    ripgrep
    bat
  ];
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
  };

  xdg.configFile.nvim-vscode.source = outOfStore ".";
}
