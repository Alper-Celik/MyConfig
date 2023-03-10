{ pkgs, nur }: with pkgs;
[

  # media players
  vlc

  pkgs.musescore
  # utulities
  ## browsers 
  pkgs.firefox
  chromium
  ## 2 steap auth
  authy
  ## office suits
  libreoffice-qt
  onlyoffice-bin
  ## file mangement
  ark
  ## time
  libsForQt5.kclock


  ## book managment
  calibre


  # dev tools
  ## editors 
  kate
  qtcreator
  ## terminal emulators
  kitty
  ## virtualization
  virt-manager
  ## accessibility 
  gnome.accerciser
  ## debuggers
  seer


  # cli depend on gui env
  wl-clipboard
  xclip

  (hiPrio cmakeWithGui)


  # games
  grapejuice
  steam
  wineWowPackages.staging
  protonup-ng

  prismlauncher # minecraft
  nur.repos.xeals.atlauncher #minecraft
  mindustry
  superTuxKart



]
