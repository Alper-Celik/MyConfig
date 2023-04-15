{ pkgs, nur }: with pkgs;
[

  # media players
  vlc

  pkgs.musescore
  # utulities
  ## browsers 
  firefox
  chromium
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
  wl-clipboard
  xclip

  (hiPrio cmakeWithGui)


  # games
  grapejuice
  wineWowPackages.staging
  protonup-ng

  prismlauncher # minecraft
  nur.repos.xeals.atlauncher #minecraft
  mindustry
  superTuxKart
]
