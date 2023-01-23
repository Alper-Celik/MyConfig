{ pkgs-u, pkgs-s, pkgs ? pkgs-s }: with pkgs ;
[
  patchelf

  # version controll
  git
  lazygit
  git-lfs

  # networking
  wget
  curl

  # manual
  man
  cht-sh
  tldr

  gnupg
  openssh

  bash
  fish
  any-nix-shell
  ncurses
  findutils

  direnv
  nix-direnv
  nix-index

  bat
  tree
  ripgrep
  comma

  # compression
  unzip
  gnutar
  zstd

  # dev tools
  ## editors
  (lowPrio pkgs-u.neovim)
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
  docker
  act



  # Fonts
  pkgs-s.nerdfonts

]
