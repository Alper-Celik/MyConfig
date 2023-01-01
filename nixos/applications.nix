{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }:
let


  vscode-with-env = (pkgs.vscode.override
    { commandLineArgs = "--enable-features=Vulkan"; }).fhsWithPackages (ps: with ps;with pkgs; [ libgnome-keyring rustup zlib openssl.dev pkg-config ]);
in
{
  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  environment.systemPackages = with pkgs; [


    ark
    libsForQt5.bismuth
    libsForQt5.kdeconnect-kde

    vlc
    # vlc




    # utulities
    pkgs-s.firefox

    patchelf

    authy

    kitty

    libreoffice-qt

    wget
    curl

    git
    lazygit
    git-lfs

    gnupg

    bash
    fish

    any-nix-shell

    comma

    bat

    direnv
    nix-direnv

    tree
    ripgrep

    cht-sh
    unzip

    gnutar

    zstd

    libsForQt5.kirigami-addons
    libsForQt5.kclock

    calibre

    gnome.accerciser

    act
    docker

    # nvidia-offload

    ## editors
    kate
    neovim

    qtcreator

    # Games
    grapejuice # roblox
    steam
    prismlauncher # minecraft
    config.nur.repos.xeals.atlauncher #minecraft
    mindustry
    superTuxKart

    # Development

    vscode-with-env

    libvirt
    virt-manager

    ## build tools
    cmake
    cmakeWithGui
    gnumake
    ninja

    cargo

    ## compilers
    gcc12
    gdb
    clang_14
    clang-tools
    lldb

    rustc

    ## runtimes
    nodejs

    jdk
    jdk8


    #lsps etc for neovim
    rnix-lsp
    sumneko-lua-language-server
    cmake-language-server
    nil
    nixpkgs-fmt
    # qml-lsp


    stylua
    python310Packages.autopep8

    # Fonts
    pkgs-s.nerdfonts

    wl-clipboard
    xclip

    python310Packages.pipx
    python310Packages.pip
    python310Packages.argcomplete
    python310Packages.libvirt
    python310Packages.pyqt5

    freerdp


  ];
  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;
  programs.steam.dedicatedServer.openFirewall = true;

  programs.kclock.enable = true;

  programs.fish.enable = true;
  programs.fish.promptInit = ''
    any-nix-shell fish --info-right | source
  '';

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "qt";
  };

  # programs.direnv.enable = true;
  # programs.direnv.nix-direnv.enable = true;

  programs.kdeconnect.enable = true;

  virtualisation.libvirtd.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "overlay2";

  programs.partition-manager.enable = true;

  programs.weylus.users = [ "alper" ];
  programs.weylus.enable = true;
  programs.weylus.openFirewall = true;
}
