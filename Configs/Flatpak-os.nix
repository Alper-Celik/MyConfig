{ pkgs, config, ... }: {
  environment.persistence."/persistent".directories = [ "/var/lib/flatpak" ];
  services.flatpak.enable = true;

  #from https://nixos.wiki/wiki/Fonts#Using_bindfs_for_font_support
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs"; # bindfs instead of bind because it resolves symlinks i think
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = [ "/share/fonts" ];
      };
    in
    {
      # Create an FHS mount to support flatpak host icons/fonts
      "/usr/share/icons" = mkRoSymBind ("/run/current-system/sw" + "/share/icons");
      "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
    };
}
