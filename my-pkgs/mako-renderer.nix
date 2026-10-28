{
  inputs,
  pkgs,
  ...
}:
let
  # MAKO pins Vulkan-Headers v1.4.365: it needs VK_KHR_present_id2 and
  # VK_EXT_present_timing, which nixpkgs' headers (1.4.363) do not provide.
  vulkan-headers-mako = pkgs.stdenv.mkDerivation {
    pname = "vulkan-headers-mako";
    version = "1.4.365";
    src = pkgs.fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "Vulkan-Headers";
      rev = "v1.4.365";
      hash = "sha256-KyHdumYx8qIgQFcr+l4L9ayKpk1/6KBa3f7OyluqKbc=";
    };
    nativeBuildInputs = [
      pkgs.cmake
      pkgs.ninja
    ];
    cmakeFlags = [
      (pkgs.lib.cmakeBool "VULKAN_HEADERS_ENABLE_TESTS" false)
      (pkgs.lib.cmakeBool "VULKAN_HEADERS_ENABLE_MODULE" false)
    ];
  };
in
pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "mako-renderer";
  version = "4.6.0";

  # Pinned by the `mako` flake input (flake = false); rev and tree hash come
  # from flake.lock, so `nix flake update mako` is the only bump. Fetching it
  # back through fetchFromGitHub keeps the fixed-output store path stable, so
  # bumping a no-op reuses the compiled output instead of rebuilding.
  src = pkgs.fetchFromGitHub {
    owner = "eugeniosegala";
    repo = "MAKO";
    rev = inputs.mako.rev;
    hash = inputs.mako.narHash;
  };

  # The CMake project lives in engine/ and expects the monorepo files above it.
  cmakeDir = "../engine";

  nativeBuildInputs = [
    pkgs.cmake
    pkgs.ninja
    pkgs.pkg-config
    pkgs.python3
    pkgs.qt6.wrapQtAppsHook
  ];
  buildInputs = [
    pkgs.qt6.qtbase
    pkgs.qt6.qtdeclarative
  ];

  cmakeFlags = [
    (pkgs.lib.cmakeBool "BUILD_TESTING" false)
    (pkgs.lib.cmakeBool "MAKO_BUILD_VK_LAYER" true)
    (pkgs.lib.cmakeBool "MAKO_BUILD_CLI" true)
    (pkgs.lib.cmakeBool "MAKO_BUILD_UI" true)
    (pkgs.lib.cmakeBool "MAKO_INSTALL_XDG_FILES" true)
    (pkgs.lib.cmakeBool "MAKO_REQUIRE_NATIVE_PACKAGE_HEADERS" true)
    (pkgs.lib.cmakeFeature "MAKO_VULKAN_HEADERS_INCLUDE_DIR" "${vulkan-headers-mako}/include")
    (pkgs.lib.cmakeFeature "MAKO_LAYER_LIBRARY_PATH" "../../../lib/libmako-render.so")
    (pkgs.lib.cmakeFeature "MAKO_SCALING_LAYER_LIBRARY_PATH" "../../../lib/libmako-render-scaling.so")
  ];

  dontUseNinjaCheck = true;

  meta = {
    description = "MAKO frame generation, scaling and shader Vulkan layer (source build)";
    homepage = "https://github.com/eugeniosegala/MAKO";
    license = pkgs.lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "mako-launch";
  };
})
