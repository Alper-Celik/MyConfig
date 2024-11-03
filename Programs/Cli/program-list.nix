{
  pkgs,
  my-pkgs,
}:
with pkgs;
[
  patchelf
  libqalculate

  # version controll
  git
  lazygit
  git-lfs
  gh # github cli

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
  # nvtopPackages.full
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

  # Fonts
  nerdfonts

]
