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
  speedtest-go

  networkmanagerapplet

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
  my-pass

  bash
  ncurses
  findutils
  psmisc

  direnv
  nix-direnv

  bat
  tree
  ripgrep
  fd
  comma
  fzf
  jq
  eza # fancy ls

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
  python310Packages.python


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
