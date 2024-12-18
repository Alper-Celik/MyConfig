{
  pkgs,
  my-pkgs,
  kdePackages ? { },
}:
with pkgs;
with kdePackages;
[
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

  trickle

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

]
