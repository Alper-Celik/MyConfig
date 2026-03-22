{
  pkgs-unstable,
  pkgs,
  my-pkgs,
  lib,
  ...
}:
{
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

}
