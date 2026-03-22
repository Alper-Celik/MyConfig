{
  pkgs-unstable,
  pkgs,
  my-pkgs,
  lib,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    package = pkgs-unstable.hyprland;
    withUWSM = true;

  };

  environment.sessionVariables =
    let
      globalQmlPkg = [
        pkgs.kdePackages.kirigami
        pkgs.kdePackages.kirigami-addons
        my-pkgs.qml-material
        my-pkgs.AlperQmlModule
      ];
    in
    {
      QT_PLUGIN_PATH = map (pkg: "${pkg}/${pkgs.qt6.qtbase.qtPluginPrefix}") globalQmlPkg;
      QML2_IMPORT_PATH = map (pkg: "${pkg}/${pkgs.qt6.qtbase.qtQmlPrefix}") globalQmlPkg;
    };

  security.pam.services = {
    "password".unixAuth = true;
    "yubikey" = {
      u2fAuth = true;
      unixAuth = false;
    };
  };

  nix.settings = {
    extra-substituters = [ "https://vicinae.cachix.org" ];
    extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
  };

  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
