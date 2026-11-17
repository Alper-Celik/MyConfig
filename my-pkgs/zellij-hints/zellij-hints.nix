# kitty-hints / tmux-thumbs style labeled URL/path overlay for zellij.
# Source comes from the `zellij-hints` flake input so it bumps with
# `nix flake update zellij-hints`; only the cargoHash (and, if ever needed,
# a tile-pin patch) is maintained here.
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

  # Upstream source as-is (its lock pins zellij-tile 0.45.1). nixpkgs' cargo
  # vendor follows the src's own Cargo.lock, so a postPatch-only tile bump
  # breaks the --offline build; only pair an override with a matching
  # regenerated lock. First test whether the 0.45.1 tile loads on the 0.46.0
  # host before adding that complexity.
  src = inputs.zellij-hints;

  # No vendored Cargo.lock: nixpkgs' cargo vendor re-resolves from the input's
  # own lock, so pin the resolved dep set with cargoHash instead. When an
  # upstream bump changes deps, reset to `cargoHash = ""`, build, copy the
  # "got: sha256-…" back.
  cargoHash = "sha256-pwo/mRrdmytNZxZrVYdraZccOSsKSvwokMVy57pDcvU=";

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
