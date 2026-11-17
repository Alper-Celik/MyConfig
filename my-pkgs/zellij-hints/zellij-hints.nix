{ pkgs, inputs, ... }:
let
  # zellij plugins are wasm32-wasip1 modules and nixpkgs only ships that cross
  # set from ~26.11 on (this flake's perSystem pkgs is nixos-26.05, which has
  # only wasm32-unknown-none), so take it from the unstable input.
  wasm =
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pkgsCross.wasm32-wasip1;
in
wasm.rustPlatform.buildRustPackage {
  pname = "zellij-hints";
  version = "0.1.0";
  src = ./.;

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [ wasm.lld ];
  env.RUSTFLAGS = "-C linker=wasm-ld";

  doCheck = false;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/wasm32-wasip1/release/*.wasm $out/zellij_hints.wasm
    runHook postInstall
  '';
}
