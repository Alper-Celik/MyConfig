{ inputs, lib, config, pkgs, ... }:
{

  hardware.opengl = {
    driSupport32Bit = true;
    enable = true;
  };




  qt = {
    enable = true;
    platformTheme = "kde";
  };
  i18n.inputMethod.enabled = "ibus";

  programs.dconf.enable = true;


}
