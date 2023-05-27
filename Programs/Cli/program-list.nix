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
  ncurses
  findutils

  direnv
  nix-direnv

  bat
  tree
  ripgrep
  fd
  comma
  fzf

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


  python310Packages.argcomplete
  ## compilers and runtimes
  (hiPrio gcc12)
  haskell.compiler.ghc96
  python310Packages.python


  (hiPrio jdk)
  jdk8
  ## debuggers
  gdb
  ## build tools
  cmakeCurses
  gnumake
  ninja

  ## containers
  distrobox
  podman

  # Fonts
  nerdfonts

]
