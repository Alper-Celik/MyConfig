{ inputs, lib, config, pkgs, specialArgs, ... }: {
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

    shellAbbrs = {

      c = "clear";
      lg = "lazygit";
      nv = "nvim";
      th = "touch";
      py = "python";

      #ls aliases
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
    };

  };

  home.packages = with pkgs;[ fzf fd bat ];
}
