{
  inputs,
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}:
{
  programs.git = {
    enable = true;

    userName = "Alper Çelik";
    userEmail = "alper@alper-celik.dev";

    signing.key = config.programs.git.userEmail;
    signing.signByDefault = true;

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };

    lfs.enable = true;
  };

}
