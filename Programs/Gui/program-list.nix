{ pkgs-u, pkgs-s, pkgs ? pkgs-s, nur }: with pkgs;
let
  vscode-with-env = (pkgs.vscode.override
    { commandLineArgs = "--enable-features=Vulkan"; }).fhsWithPackages (ps: with ps;with pkgs; [ libgnome-keyring rustup zlib openssl.dev pkg-config ]);

in
[

  # media players
  vlc

  # utulities
  ## browsers 
  pkgs-s.firefox
  chromium
  ## 2 steap auth
  authy
  ## office suits
  libreoffice-qt
  onlyoffice-bin
  ## file mangement
  ark
  ## time
  libsForQt5.kirigami-addons # needed for kclock
  libsForQt5.kclock

  ## book managment
  calibre


  # dev tools
  ## editors 
  kate
  qtcreator
  vscode-with-env
  ## terminal emulators
  kitty
  ## virtualization
  virt-manager
  ## accessibility 
  gnome.accerciser


  # cli depend on gui env
  wl-clipboard
  xclip

  cmakeWithGui


  # games
  grapejuice
  steam
  protonup-ng

  prismlauncher # minecraft
  nur.repos.xeals.atlauncher #minecraft
  mindustry
  superTuxKart



]
