{
  pkgs,
  my-pkgs,
  nur,
  kdePackages ? { },
}:
with pkgs;
with kdePackages;
[

  # media players
  vlc
  haruna

  obs-studio
  # musescore

  # utulities
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
  libreoffice-qt
  # onlyoffice-bin
  ## file mangement
  ark
  onedrivegui
  ## book managment
  calibre

  # kcalc
  qalculate-qt
  # dev tools
  jetbrains-toolbox
  godot_4
  libresprite
  pixelorama
  ## editors 
  kate
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
  clipboard-jh
  wl-clipboard
  xclip

  (hiPrio cmakeWithGui)

]
