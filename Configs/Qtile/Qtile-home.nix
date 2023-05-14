{ pkgs, config, specialArgs, ... }:
{

  xdg.configFile.qtile.source = config.lib.file.mkOutOfStoreSymlink (
    # TODO: extract to lib somehow
    if builtins.hasAttr "configDir" specialArgs
    then "${specialArgs.configDir}/Configs/Qtile"
    else ./.
  );
}
