{
  pkgs,
  pkgs-stable,
  inputs,
  config,
  pkgs-unstable,
  ...
}:
{

  stylix = {
    enable = true;
    # autoEnable = false;

    image = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Path/contents/images/2560x1600.jpg";
    polarity = "dark";
    base16Scheme = "${inputs.nightfox-nvim}/extra/carbonfox/base16.yaml"; # TODO: maybe port from nightfox

    cursor = {
      package = pkgs.kdePackages.breeze;
      name = "breeze_cursors";
      size = 24;
    };

    fonts = {
      monospace = {
        package =  (pkgs.nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; });
        name = "JetBrainsMono Nerd Font Mono";
      };
      # serif = config.stylix.fonts.monospace;
      # sansSerif = config.stylix.fonts.monospace;
      # emoji = config.stylix.fonts.monospace;

      sizes = {
        popups = 10;
        applications = 10;
        desktop = 10;
        terminal = 9;
      };
    };

  };

}
