{ inputs, pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
    extraPackages = epkgs: [ epkgs.vterm ];
  };
  # home.packages = with pkgs;[ emacs-gtk ];
  home.file.".emacs.d" = {
    source = inputs.spacemacs-git;
    recursive = true;
  };
}
