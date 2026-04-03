{ ... }:
{
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      # colorScheme = "carbonfox";
      lookAndFeel = "org.kde.breezedark.desktop";
      theme = "breeze-dark";
    };
  };

}
