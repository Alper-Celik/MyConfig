{ pkgs, ... }:
{

  stylix = {
    image = pkgs.fetchurl {
      url = "https://www.bing.com//th?id=OHR.StartPointLight_ROW3327480520_1920x1080.jpg&rf=LaDigue_1920x1080.jpg&pid=hp";
      sha256 = "sha256-pE+pvdznEgrusie1bgarjzAC3I1aQF1RinoSCJK2FYc=";
    };
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.nerdfonts;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sizes.terminal = 9;
    };
  };

}
