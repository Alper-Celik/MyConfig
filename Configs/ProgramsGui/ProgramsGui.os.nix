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

      pkgs-stable.unityhub

      # media players
      vlc
      audacity
      haruna

      feishin

      spotify

      kdePackages.kasts

      obs-studio
      # musescore

      # utulities
      bitwarden-desktop
      nextcloud-client
      ## browsers
      #firefox moved to home manager
      chromium
      vivaldi
      ## mail and chat
      thunderbird
      discord
      element-desktop
      telegram-desktop
      # neochat
      ## office suits
      libreoffice-qt6
      onlyoffice-desktopeditors

      ## file mangement
      ark
      onedrivegui
      ## book managment
      calibre

      # kcalc
      qalculate-qt
      # dev tools
      jetbrains-toolbox
      libresprite
      ## editors
      kate
      obsidian
      ## accessibility
      (accerciser.override { python3 = python311; })
      kdePackages.accessibility-inspector
      ## debuggers
      seer
      hotspot

      ## networking
      protonvpn-gui

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

  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = [ config.users.users.alper.name ];
  };
}
