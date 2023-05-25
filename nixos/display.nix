{ inputs, lib, config, pkgs, ... }:
{

  hardware.opengl = {
    driSupport32Bit = true;
    enable = true;
  };




  i18n.inputMethod.enabled = "ibus";

  programs.dconf.enable = true;


}
