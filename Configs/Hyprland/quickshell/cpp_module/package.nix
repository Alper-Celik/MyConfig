{
  inputs,

  stdenv,
  cmake,
  pkg-config,
  qtbase,
  qtdeclarative,
  wrapQtAppsHook,
  lib,
}:

stdenv.mkDerivation {
  src = ../cpp_module;
  pname = "AlperQmlModule";
  version = "0.0.1";
  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
  ];

  cmakeFlags = [
    (lib.cmakeFeature "QT_INSTALL_QML" qtbase.qtQmlPrefix)
  ];
}
