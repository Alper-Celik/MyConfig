{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, ... }: {
  programs.git = {
    enable = true;
    userName = "Alper Çelik";
    userEmail = "dev.alpercelik@gmail.com";
    signing.signByDefault = true;
    signing.key = "Alper Çelik";
    extraConfig =
      {
        init.defaultBranch = "main";
      };

    lfs.enable = true;
  };

}
