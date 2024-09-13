{
  pkgs,
  inputs,
  config,
  ...
}:
{

  stylix = {
    # enable = true;

    image = "${pkgs.kdePackages.breeze}/share/wallpapers/Next/contents/images_dark/3840x2160.png";
    polarity = "dark";
    base16Scheme = "${inputs.base16-oxocarbon}/base16-oxocarbon-dark.yaml"; # TODO: maybe port from nightfox
    fonts = {
      monospace = {
        package = pkgs.nerdfonts;
        name = "JetBrainsMono Nerd Font Mono";
      };
      # serif = config.stylix.fonts.monospace;
      # sansSerif = config.stylix.fonts.monospace;
      # emoji = config.stylix.fonts.monospace;

      sizes = {
        popups = 10;
        applications = 10;
        desktop = 10;
        terminal = 10;
      };
    };

  };

}
