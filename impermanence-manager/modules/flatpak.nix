{ lib, config, ... }:
{
  options.impermanence-manager.permanence.flatpak = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.impermanence-manager.autoPermanence && config.services.flatpak.enable;
      example = true;
      description = lib.mdDoc "Whether to enable magic.";
    };

    impermanence-info = lib.mkOption
      {
        default = { };
      }
      };

  }
