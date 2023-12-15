{ inputs, pkgs, ... }:
{
  home.packages = with pkgs;[ emacs ];
  home.file.".emacs.d" = {
    source = inputs.spacemacs-git;
    recursive = true;
  };
}
