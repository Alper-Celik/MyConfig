{
  pkgs,
  my-pkgs,
  nur,
}:
with pkgs;
[

  # media players
  vlc

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
  onedrivegui
  ## book managment
  # calibre

  # dev tools
  jetbrains-toolbox
  libresprite
  ## editors 
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

]
