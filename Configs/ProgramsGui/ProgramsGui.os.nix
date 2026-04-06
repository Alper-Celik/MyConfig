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
{

  environment.systemPackages =
    with pkgs;
    with kdePackages;
    [
      # media players and music
      vlc
      audacity
      haruna
      finamp

      feishin
      puddletag
      kid3
      spotify
      kdePackages.kasts
      easyeffects
      kdePackages.gwenview

      obs-studio
      # musescore

      # utulities
      nextcloud-client
      kdePackages.dolphin
      kdePackages.konsole
      keepassxc
      ## browsers
      #firefox moved to home manager
      chromium
      ## mail and chat
      thunderbird-bin
      discord
      element-desktop
      # neochat
      ## office suits
      libreoffice-qt6
      onlyoffice-desktopeditors

      ## file mangement
      ark
      onedrivegui
      ## book managment
      # calibre

      # kcalc
      qalculate-qt
      # dev tools
      jetbrains-toolbox
      jetbrains.rider
      jetbrains.clion
      jetbrains.pycharm
      android-studio

      libresprite
      ## editors
      kate
      obsidian
      ## accessibility
      accerciser
      kdePackages.accessibility-inspector
      ## debuggers
      seer
      hotspot

      ## networking
      protonvpn-gui
      postman

      ## download managers
      qbittorrent

      # cli depend on gui env
      wl-clipboard
      xclip
      libnotify

    ];
  programs.kclock.enable = true;
  programs.kdeconnect.enable = true;

  programs.partition-manager.enable = true;

  programs.gamemode.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.ANDROID_HOME = "/home/alper/Android/Sdk/";

  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = [ config.users.users.alper.name ];
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  users.users.alper.extraGroups = [ "wireshark" ];
  # needed for avaloniaui .net
  environment.sessionVariables.LD_LIBRARY_PATH = [
    "${pkgs.fontconfig.lib}/lib"
    "${pkgs.xorg.libX11}/lib"
    "${pkgs.xorg.libICE}/lib"
    "${pkgs.xorg.libSM}/lib"
  ];
}
