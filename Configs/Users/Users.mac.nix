{
  inputs,
  specialArgs,
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.stylix.darwinModules.stylix
  ];

  users.knownUsers = [ "alper" ];
  users.users.alper = {
    description = "Alper Çelik";
    home = "/Users/alper";
    uid = 501; # first macOS user account
  };

  home-manager = {
    extraSpecialArgs = specialArgs;
    users.alper = {
      imports = [ ../../home-manager/home.nix ];
      home.username = "alper";
      home.homeDirectory = "/Users/alper";
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "home-manager-backup";
  };
}
