{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-stable,
  my-pkgs,
  specialArgs,
  ...
}:
{

  environment.systemPackages =
    with pkgs;
    with kdePackages;
    [
      config.boot.kernelPackages.perf

      patchelf
      libqalculate

      # version controll
      git
      lazygit
      git-lfs
      gh # github cli

      restic
      rclone
      onedrive

      # networking
      wget
      curl
      aria2
      speedtest-go

      networkmanagerapplet

      python3Packages.yt-dlp
      ffmpeg

      # manual
      man
      cht-sh
      tldr
      man-pages
      man-pages-posix

      gnupg
      openssh
      sshfs
      my-pass

      bash
      ncurses
      tmux
      findutils
      psmisc

      devenv
      direnv
      nix-direnv
      deploy-rs

      bat
      tree
      ripgrep
      fd
      comma
      fzf
      jq
      yq
      eza # fancy ls

      smartmontools

      htop
      btop
      nvtopPackages.full
      # compression
      unzip
      gnutar
      zstd

      # dev tools
      jdk
      (maven.override { jdk_headless = jdk; })
      (gradle.override { java = jdk; })
      ## editors
      # (lowPrio pkgs.neovim) use home manager
      nano

      python3Packages.argcomplete
      ## compilers and runtimes
      ## debuggers
      gdb
      ## build tools
      gnumake
      ninja

    ];
  environment.sessionVariables = {
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME = "\${HOME}/.local/bin";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    # note: this doesn't replace PATH, it just adds this to it
    PATH = [
      "\${XDG_BIN_HOME}"
    ];
  };
  documentation.dev.enable = true;

  programs.gnupg.agent = {
    enable = true;
    # pinentryFlavor = "qt";
  };

  programs.firejail = {
    enable = true;
  };
  security.sudo.extraConfig = "Defaults pwfeedback";
}
