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

    signing.key = config.programs.git.settings.user.email;
    signing.signByDefault = true;

    settings = {
      user.name = "Alper Çelik";
      user.email = "alper@alper-celik.dev";

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };

    lfs.enable = true;
  };

}
