{
  inputs,
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}:
{
  programs.fish = {

    enable = true;

    functions = {
      take = ''
        mkdir -pv $argv
        cd $argv
      '';
      fish_greeting = "";
    };

    plugins = [
      {
        name = "my settings";
        src = ./.;
      }
      {
        name = "fzf.fish";
        src = inputs.fzf-fish;
      }
      {
        name = "autopair.fish";
        src = inputs.autopair-fish;
      }
      {
        name = "bang bang";
        src = inputs.bang-bang-fish;
      }
    ];

    shellAliases = {
      trash = "gio trash";
      ll = "eza -a -l --icons";
      ls = "eza --icons -a";

    };
    shellAbbrs = {
      ":q" = "exit"; # yes i accidently type :q intead of exit on terminal
      shelp = "nix-shell -p";

      make = "make -j (nproc)";

      c = "clear";
      lg = "lazygit";
      nv = "nvim";
      th = "touch";
      py = "python";
    };

  };

  home.packages = with pkgs; [
    fzf
    fd
    bat
    glib
  ];
}
