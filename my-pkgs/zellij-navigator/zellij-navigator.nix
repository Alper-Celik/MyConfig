{ pkgs, ... }:
let
  # zellij plugins are wasm32-wasip1 modules; nixpkgs ships a cross rust
  # platform for exactly this (see pkgs/by-name/ze/zellij/plugins/rust).
  wasm = pkgs.pkgsCross.wasm32-wasip1;
in
wasm.rustPlatform.buildRustPackage {
  pname = "zellij-navigator";
  version = "0.3.0-niri";
  src = ./.;

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [ wasm.lld ];
  env.RUSTFLAGS = "-C linker=wasm-ld";

  doCheck = false;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/wasm32-wasip1/release/*.wasm $out/vim_zellij_navigator.wasm
    runHook postInstall
  '';
}
