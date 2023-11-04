{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "firefox-pwa";
  version = "2.8.0";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  src = fetchFromGitHub {
    owner = "filips123";
    repo = "PWAsForFirefox";
    rev = "v${version}";
    hash = "sha256-Uhr848H+7a9Qy3XJPKi0mPOU2RZtJSjpCCPJtSJ+6Ys=";
  };

  postInstall = ''
    # mostly from upstream cargo-make Make.toml https://github.com/filips123/PWAsForFirefox/blob/20316bd7cccba15502d6f2a5c870e4ca9d9b65b0/native/Makefile.toml#L35

    install -D manifests/linux.json $out/lib/mozilla/native-messaging-hosts/firefoxpwa.json

    mkdir -p $out/share/firefoxpwa/userchrome/
    cp -R userchrome/* $out/share/firefoxpwa/userchrome/
  '';

  sourceRoot = "${src.name}/native";
  cargoLock = {
    lockFile = ("${src.outPath}/native/Cargo.lock");
    outputHashes = {
      "data-url-0.3.0" = "sha256-ZJBRkd4s47ywYnGbzxsQyr0JRgjAXZryVthszKJreTU=";
      "mime-0.4.0-a.0" = "sha256-LjM7LH6rL3moCKxVsA+RUL9lfnvY31IrqHa9pDIAZNE=";
      "web_app_manifest-0.0.0" = "sha256-G+kRN8AEmAY1TxykhLmgoX8TG8y2lrv7SCRJlNy0QzA=";
    };

  };
}
