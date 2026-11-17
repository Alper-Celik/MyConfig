# Agent Instructions: NixOS Configuration

## Core Architecture

- **Structure**: This is a Flake-based NixOS/Home Manager configuration.
- **`Configs/`**: Modules are split into `.os.nix` (NixOS) and `.home.nix` (Home Manager) or with `<config>.<hostname>.nix` prefix like `./Configs/DisplayManager/DisplayManager.os.lenovo-ideapad-510.nix`
- **`my-lib/`**: Contains core helpers. Use `my-lib.maybeOutOfStore` for live editable path resolution.
- **`my-pkgs/`**: Local package definitions (e.g., `qml-material`) which is possible to use outside the config by including this flake on other projects.

## my-pkgs: External Sources & Update Cycle

- **Source from flake inputs, not vendored trees**: packages built from unmodified third-party sources (e.g. `my-pkgs/zellij-hints/zellij-hints.nix`) take their `src` from a `flake = false` input in `flake.nix`, so they can be bumped properly with `nix flake update <input-name>`. NEVER copy a source tree into `my-pkgs/` for this model. Exception: true forks that need local edits keep their whole tree in `my-pkgs/` (e.g. `zellij-navigator` is a vendored arrow-key fork).
- **Hash management**: Rust crates built with `buildRustPackage` + an external `src` use `cargoHash` (nixpkgs' cargo vendor follows the src's own `Cargo.lock`; a hand-maintained lock fights it). Update cycle for a bump: `nix flake update <input>` → if deps changed, set `cargoHash = ""`, run `nix build`, copy the printed `got: sha256-…` back, build again.
- **Keep wasm/host pairs consistent**: zellij plugins are wasm32-wasip1 modules cross-built via `pkgsCross.wasm32-wasip1.rustPlatform.buildRustPackage` from `nixpkgs-unstable` (26.05 pkgs lacks that cross set). When zellij itself is bumped, check the plugin's `zellij-tile` pin against the new host version — if a bump is needed, pair the pin change with a regenerated `Cargo.lock` (a `postPatch`-only bump breaks the offline vendor step).
- **Verify a package change with the narrowest build**: `nix build .#packages.aarch64-linux.<pname>`, then confirm the expected artifact exists in the output path.

## Live-Editing (Out-of-Store Symlinks)

frequently edited GUI/App configs use a symlinking pattern to allow editing files without a `nixos-rebuild`.

- **Convention**: `outOfStrore = x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);`
- **Impact**: When modifying Neovim (`Configs/Neovim/`), Hyprland (`Configs/Hyprland/`), or Quickshell (`Configs/Hyprland/quickshell/`), edit the source files directly. Do not wrap them in Nix strings unless explicitly asked.

## Neovim (LazyVim)

- **Location**: `Configs/Neovim/`
- **Plugins**: Add to `lua/plugins/*.lua`.
- **Dependencies**: System dependencies (LSPs, formatters) MUST be added to the `language-tools` list in `Neovim.home.nix`.

## Hyprland & UI

- **Hyprland**: Main config is `Configs/Hyprland/hyprland.conf`. Window rules are modularized in `hyprland-modules/`.
- **Quickshell**: UI components are QML files in `Configs/Hyprland/quickshell/`.
- **Scripts**: Shell scripts in `Configs/Hyprland/scripts/` are added to the user's `PATH` via Home Manager.
