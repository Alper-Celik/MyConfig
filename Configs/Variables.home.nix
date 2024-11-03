{ config, lib, ... }@attrs:
with lib;

let
  cfg = config.MyConfig;
  isOnNixosConfig = if builtins.hasAttr "osConfig" attrs then true else false;
in

{

  options.MyConfig = {
    tags = mkOption {
      type = types.listOf types.str;
      default = if isOnNixosConfig then attrs.osConfig.MyConfig.tags else [ ];
    };

    isOnNixosConfig = {
      type = types.bool;
      default = isOnNixosConfig;
    };

  };

  config = {

  };
}
