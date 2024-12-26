{
  inputs,
  lib,
  config,
  pkgs,
  my-pkgs,
  specialArgs,
  ...
}:
{

  environment.systemPackages =
    with pkgs;
    with kdePackages;
    [

      dotnetCorePackages.sdk_9_0
      unityhub

      # media players
      vlc
      haruna

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
      # neochat
      ## office suits
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
      libresprite
      ## editors
      kate
      obsidian
      ## terminal emulators
      kitty
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
  programs.droidcam.enable = true;

  programs.kclock.enable = true;
  programs.kdeconnect.enable = true;

  programs.partition-manager.enable = true;

  programs.gamemode.enable = true;
  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true;
  #   dedicatedServer.openFirewall = true;
  # };

  # Steam needs this to find Proton-GE
  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

  programs.weylus.users = [ "alper" ];
  programs.weylus.enable = true;
  programs.weylus.openFirewall = true;
}
