{ pkgs, inputs, config, ... }:
{

  stylix = {
    image = pkgs.fetchurl {
      url = "https://www.bing.com//th?id=OHR.StartPointLight_ROW3327480520_1920x1080.jpg&rf=LaDigue_1920x1080.jpg&pid=hp";
      sha256 = "sha256-pE+pvdznEgrusie1bgarjzAC3I1aQF1RinoSCJK2FYc=";
    };
    polarity = "dark";
    base16Scheme = "${inputs.base16-oxocarbon}/base16-oxocarbon-dark.yaml"; #TODO: maybe port from nightfox
    fonts = {
      monospace = {
        package = pkgs.nerdfonts;
        name = "JetBrainsMono Nerd Font Mono";
      };
      # serif = config.stylix.fonts.monospace;
      # sansSerif = config.stylix.fonts.monospace;
      # emoji = config.stylix.fonts.monospace;

      sizes = {
        popups = 9;
        applications = 9;
        desktop = 9;
        terminal = 9;
      };
    };
  };

}
