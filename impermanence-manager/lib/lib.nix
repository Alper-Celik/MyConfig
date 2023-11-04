{ lib, config, ... }:
{
  options.impermanence-manager.autoPermanence = lib.mkOption
    {
      type = lib.types.bool;
      default = true;
      example = false;
      description = lib.mdDoc "whater to automatically enable permanence for enabled services and configurations";
    };


}
