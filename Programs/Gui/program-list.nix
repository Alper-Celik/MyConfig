{ pkgs, my-pkgs, nur, kdePackages ? { } }: with pkgs ;with kdePackages;
[

  # media players
  vlc
  haruna

  obs-studio
  # musescore

  # utulities
  ## browsers 
  (firefox.override { nativeMessagingHosts = [ plasma-browser-integration passff-host ]; })
  chromium
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
  ## book managment
  calibre

  kcalc
  # dev tools
  godot_4
  libresprite
  pixelorama
  ## editors 
  kate
  pkgs.vscode
  ## terminal emulators
  kitty
  ## virtualization
  virt-manager
  ## accessibility 
  accerciser
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


  # games
  # heroic
  legendary-gl
  # grapejuice
  wineWowPackages.stagingFull
  protonup-ng


  (hiPrio jdk8)
  jdk
  prismlauncher # minecraft
  atlauncher #minecraft
  mindustry
]
