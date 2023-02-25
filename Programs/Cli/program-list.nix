{ pkgs }: with pkgs ;
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

  python310Packages.yt-dlp
  ffmpeg

  # manual
  man
  cht-sh
  tldr
  man-pages
  man-pages-posix

  gnupg
  openssh

  bash
  fish
  any-nix-shell
  ncurses
  findutils

  direnv
  nix-direnv

  cachix

  bat
  tree
  ripgrep
  fd
  comma
  fzf

  htop
  btop
  # compression
  unzip
  gnutar
  zstd

  # dev tools
  ## editors
  (lowPrio pkgs.neovim)
  nano


  python310Packages.argcomplete
  ## compilers and runtimes
  (hiPrio gcc12)
  clang_14
  python310Packages.python

  rustc

  nodejs
  (hiPrio jdk)
  jdk8
  ## debuggers
  lldb
  gdb
  ## build tools
  cmakeCurses
  gnumake
  ninja

  cargo
  ## containers
  distrobox
  podman
  act



  # Fonts
  pkgs.nerdfonts

]
