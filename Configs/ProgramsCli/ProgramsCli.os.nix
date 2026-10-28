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
let
  ompUpstream = inputs.omp.packages.${pkgs.stdenv.hostPlatform.system}.omp;

  # Chromium for omp's builtin browser only -- pkgs.chromium itself is left
  # alone, because it is only ever broken when it is spawned from an
  # environment that exports a mismatched toolchain dir (a project devshell):
  # chromium's launcher keeps the inherited LD_LIBRARY_PATH and only appends to
  # it, so that entry shadows the binary's DT_RUNPATH and it dies before
  # main() with `libgcc_s.so.1: version GCC_16.0 not found`. Start this copy
  # from an empty LD_LIBRARY_PATH instead; chromium's own wrapper re-adds
  # libva/pipewire/wayland/gtk/krb5, everything else comes from the closure.
  browser = pkgs.symlinkJoin {
    pname = "chromium-for-omp";
    version = lib.getVersion pkgs.chromium;
    paths = [
      pkgs.chromium
      pkgs.chromium.sandbox
    ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    meta = pkgs.chromium.meta;
    postBuild = ''
      rm -f "$out/bin/chromium" "$out/bin/chromium-browser"
      makeWrapper ${pkgs.chromium}/bin/chromium "$out/bin/chromium" --unset LD_LIBRARY_PATH
      ln -s chromium "$out/bin/chromium-browser"
    '';
  };

  # omp's managed Chromium can not install itself on aarch64 (Chrome for
  # Testing publishes no linux/arm64 builds) and would download ~150 MB
  # elsewhere, so point puppeteer at the copy above.
  omp = pkgs.symlinkJoin {
    pname = "omp";
    version = lib.getVersion ompUpstream;
    paths = [ ompUpstream ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    meta = ompUpstream.meta;
    postBuild = ''
      rm -f "$out/bin/omp"
      makeWrapper ${ompUpstream}/bin/omp "$out/bin/omp" \
        --set PUPPETEER_EXECUTABLE_PATH ${browser}/bin/chromium
    '';
  };
in
{

  environment.systemPackages =
    with pkgs;
    with kdePackages;
    [
      perf

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
      httpie
      aria2
      speedtest-go

      newman

      networkmanagerapplet

      python3Packages.yt-dlp
      ffmpeg
      imagemagick

      # manual
      man
      cht-sh
      tealdeer
      man-pages
      man-pages-posix
      # reuse

      gnupg
      openssh
      sshfs
      my-pass

      bash
      ncurses
      tmux
      zellij
      findutils
      psmisc

      # devenv
      deploy-rs
      just

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
      zip
      unzip
      gnutar
      zstd

      # dev tools
      jdk17
      (maven.override { jdk_headless = jdk; })
      (gradle.override { java = jdk; })
      ## editors
      # (lowPrio pkgs.neovim) use home manager
      nano

      omp

      python3Packages.argcomplete
      ## compilers and runtimes
      ## debuggers
      gdb
      ## build tools
      gnumake
      ninja

      ## networking
      ipcalc
      dig
      tcpdump

    ];
  environment.sessionVariables = {
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME = "\${HOME}/.local/bin";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    # note: this doesn't replace PATH, it just adds this to it
    PATH = [
      "/home/alper/.cache/.bun/bin"
      "/home/alper/.local/bin"
    ];
  };
  documentation.dev.enable = true;

  programs.direnv.enable = true;

  programs.gnupg.agent = {
    enable = true;
    # pinentryFlavor = "qt";
  };

  programs.firejail = {
    enable = true;
  };
  security.sudo.extraConfig = "Defaults pwfeedback";
}
