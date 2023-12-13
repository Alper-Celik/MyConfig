{ specialArgs, inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.alper = {
    hashedPassword = "$y$j9T$L8ejwQ5VJJvsEKYy7KreS1$.HCfbcThbris8W.owNtpKhFzniA75naJDQ2DBrOaRF9";
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
