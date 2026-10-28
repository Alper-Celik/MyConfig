# Update every pinned dependency: flake inputs and Decky plugin pins.
update: update-flake update-decky

# Update all flake inputs.
update-flake:
    nix flake update

# Re-resolve Decky plugins from decky-plugins.txt (latest GitHub releases) and
# rewrite decky-plugins.nix.
update-decky:
    ./Configs/Games/update-decky-plugins.py
