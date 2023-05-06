{ inputs, lib, config, pkgs, specialArgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Alper Çelik";
    userEmail = "dev.alpercelik@gmail.com";
    signing.signByDefault = true;
    signing.key = "Alper Çelik";
    extraConfig =
      {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };

    lfs.enable = true;
  };

}
