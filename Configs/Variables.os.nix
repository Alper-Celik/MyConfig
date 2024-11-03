{ config, lib, ... }:

with lib;

let
  cfg = config.MyConfig;
in

{

  options.MyConfig = {
    tags = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

  };

  config = {
    # system.nixos.tags = cfg.tags;
  };

}
