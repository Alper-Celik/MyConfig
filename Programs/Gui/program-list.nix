{ pkgs, my-pkgs, nur, kdePackages ? { } }: with pkgs ;with kdePackages;
[

  # media players
  vlc
  haruna

  obs-studio
  musescore
  # utulities
  ## browsers 
  (firefox.override { extraNativeMessagingHosts = [ passff-host ]; })
  chromium
  ## mail and chat
  thunderbird
  discord
  element-desktop
  neochat
  ## 2 steap auth
  authy
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
  ## terminal emulators
  kitty
  ## virtualization
  virt-manager
  ## accessibility 
  gnome.accerciser
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

  prismlauncher # minecraft
  nur.repos.xeals.atlauncher #minecraft
  mindustry
]
