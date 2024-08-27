# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, specialArgs, ... }:


{

  imports = [

    ../Programs/Cli/nixos-configrations.nix
    ../Programs/Gui/nixos-configrations.nix

    ../Configs/configs-os.nix
  ];






  nixpkgs.config.allowUnfree = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = specialArgs.stateVersion; # Did you read the comment?

}
