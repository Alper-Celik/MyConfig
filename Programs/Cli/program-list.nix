{ pkgs, my-pkgs, kdePackages ? { } }: with pkgs ; with kdePackages;
[
  patchelf

  # version controll
  git
  lazygit
  git-lfs
  gh # github cli

  # networking
  wget
  curl
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
  my-pass

  bash
  ncurses
  tmux
  findutils
  psmisc

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
  eza # fancy ls

  trickle

  smartmontools

  htop
  btop
  # compression
  unzip
  gnutar
  zstd

  # dev tools
  ## editors
  # (lowPrio pkgs.neovim) use home manager
  nano


  python3Packages.argcomplete
  ## compilers and runtimes
  (pkgs.python3.withPackages (p: [
    p.pyside6
  ]))


  (hiPrio jdk8)
  jdk
  ## debuggers
  gdb
  ## build tools
  cmakeCurses
  gnumake
  ninja

  ## containers
  distrobox
  toolbox
  podman

  # Fonts
  nerdfonts

]
