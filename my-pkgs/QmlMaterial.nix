{ inputs, pkgs, ... }:
pkgs.callPackage (
  {
    inputs,

    stdenv,
    cmake,
    pkg-config,
    qt6,
    lib,
  }:

  stdenv.mkDerivation {
    src = inputs.QmlMaterail;
    pname = "qml-material";
    version = "0.1.5";
    nativeBuildInputs = [
      cmake
      pkg-config
      qt6.wrapQtAppsHook
    ];

    buildInputs = [
      qt6.qtbase
      qt6.qtdeclarative
    ];

    cmakeFlags = [
      (lib.cmakeFeature "QT_INSTALL_QML" qt6.qtbase.qtQmlPrefix)
    ];
  }
) { inherit inputs; }
