# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, specialArgs, ... }:


{

  imports = [

    # home manager
    inputs.home-manager.nixosModules.home-manager

    # Import your generated (nixos-generate-config) hardware configuration
    (./${specialArgs.hardware}/hardware-configuration.nix)

    ./display.nix
    ./printing.nix
    ./ccache.nix

    ../Programs/Cli/nixos-configrations.nix
    ../Programs/Gui/nixos-configrations.nix

  ];

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;

    };
  };




  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.plymouth.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = [ "ntfs3" ];
  zramSwap.enable = true;

  systemd.oomd.enable = false; #dont kill running programms pleaaaaaaase !!

  networking.hostName = specialArgs.hardware; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "C.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "trq";
    # useXkbContrg = true; # use xkbOptions in tty.
  };

  services.xserver.layout = "tr";

  # Enable sound.
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.bluetooth.enable = true;
  environment.systemPackages = with pkgs;[ libsForQt5.bluedevil libsForQt5.bluez-qt pkgs.openobex pkgs.obexftp ];
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alper = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];

    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
    ];
    shell = pkgs.fish;
  };
  home-manager.extraSpecialArgs = specialArgs;
  home-manager.users.alper = ../home-manager/home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";




  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = specialArgs.stateVersion; # Did you read the comment?






}
