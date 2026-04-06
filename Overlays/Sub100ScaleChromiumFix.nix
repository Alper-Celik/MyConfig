final: prev:
let
  apps = [
    "obsidian"
    # "feishin"
    "chromium"
    "discord"
    "element-desktop"
    # "postman"
  ];
  overlay = builtins.foldl' (
    acc: app:
    acc
    // {
      "${app}" = prev.${app}.override {
        commandLineArgs = "--disable-features=WaylandFractionalScaleV1";
      };
    }
  ) { } apps;

in
overlay
