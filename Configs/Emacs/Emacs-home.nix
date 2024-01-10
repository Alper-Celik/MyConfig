{ inputs, pkgs, config, my-lib, specialArgs, ... }:
let
  current-dir = "Configs/Emacs";
  outOfStrore = x:
    config.lib.file.mkOutOfStoreSymlink
    (my-lib.maybeOutOfStore specialArgs current-dir x);

in {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
    extraPackages = epkgs: [ epkgs.vterm ];
  };
  home.packages = with pkgs; [ nixfmt ];
  home.file.".emacs.d" = {
    source = inputs.spacemacs-git;
    recursive = true;
  };
  home.file.".spacemacs.d".source = outOfStrore ".";
}
