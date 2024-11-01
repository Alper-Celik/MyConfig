{
  inputs,
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}:
{
  systemd.user.services.tide-config = {
    Unit.Description = "tide config for fish shell";
    Service.ExecStart = "${pkgs.fish}/bin/fish ${pkgs.writeText "tide-config" ''
      tide configure --auto \
      --style=Rainbow \
      --prompt_colors='True color' \
      --show_time='24-hour format' \
      --rainbow_prompt_separators=Angled \
      --powerline_prompt_heads=Round \
      --powerline_prompt_tails=Round \
      --powerline_prompt_style='Two lines, character and frame' \
      --prompt_connection=Dotted \
      --powerline_right_prompt_frame=Yes \
      --prompt_connection_andor_frame_color=Dark \
      --prompt_spacing=Sparse \
      --icons='Many icons' \
      --transient=No
    ''}";
    Install.WantedBy = [ "default.target" ];
  };

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
      {
        name = "tide shell";
        src = inputs.tide-fish;
      }
    ];

    shellAliases = {
      trash = "gio trash";
      ll = "eza -a -l --icons";
      ls = "eza --icons -a";
      icat = "kitten icat";
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
