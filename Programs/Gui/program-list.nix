{ pkgs, nur }: with pkgs;
[

  # media players
  vlc

  obs-studio
  musescore
  # utulities
  ## browsers 
  (firefox.override { extraNativeMessagingHosts = [ passff-host ]; })
  chromium
  ## mail and chat
  thunderbird
  telegram-desktop
  discord
  element-desktop
  ## 2 steap auth
  authy
  ## office suits
  libreoffice-qt
  # onlyoffice-bin
  ## file mangement
  ark
  ## book managment
  calibre


  # dev tools
  ## editors 
  kate
  # qtcreator
  ## terminal emulators
  kitty
  ## virtualization
  virt-manager
  ## accessibility 
  gnome.accerciser
  ## debuggers
  seer
  hotspot


  # cli depend on gui env
  clipboard-jh
  wl-clipboard
  xclip

  (hiPrio cmakeWithGui)


  # games
  lutris
  heroic
  grapejuice
  wineWowPackages.staging
  protontricks
  protonup-ng

  prismlauncher # minecraft
  nur.repos.xeals.atlauncher #minecraft
  mindustry
  superTuxKart
]
