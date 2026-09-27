{ config, lib, ... }:
{
  programs.plasma = lib.mkIf (!config.x-headless) {
    enable = true;

    workspace = {
      clickItemTo = "select";
      # colorScheme = "carbonfox";
      lookAndFeel = "org.kde.breezedark.desktop";
      theme = "breeze-dark";
    };
  };

}
