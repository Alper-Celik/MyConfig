{ specialArgs, inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alper = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];

    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "podman"
    ];
  };
  home-manager = {
    extraSpecialArgs = specialArgs;
    users.alper = ../../home-manager/home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };
}
