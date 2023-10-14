{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "firefox-pwa";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "filips123";
    repo = "PWAsForFirefox";
    rev = "v${version}";
    hash = "";
  };

  cargoHash = "";

}
