{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }: {
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
}
