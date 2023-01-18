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


  direnv
  nix-direnv

  bat
  tree
  ripgrep
  comma

  # compression
  unzip
  gnutar
  zstd

  # dev tools
  ## lsp s
  rnix-lsp
  sumneko-lua-language-server
  cmake-language-server
  nil
  clang-tools


  python310Packages.argcomplete
  ## formatters
  nixpkgs-fmt
  stylua
  python310Packages.autopep8
  cmake-format
  ## editors
  neovim
  nano
  ## compilers and runtimes
  (hiPrio gcc12)
  clang_14

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
  docker
  act



  # Fonts
  pkgs-s.nerdfonts

]
