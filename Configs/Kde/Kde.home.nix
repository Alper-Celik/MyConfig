{
  inputs,
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}:
let
  isKde = if lib.elem "Kde" config.MyConfig.tags then true else false;
in
{
  home.packages = if isKde then [ inputs.plasma-manager.packages.${pkgs.system}.rc2nix ] else [ ];
  programs.plasma =
    if isKde then
      {
        enable = true;

        kwin = {
          virtualDesktops = {
            number = 9;
            rows = 3;
          };
        };

        workspace = {
          clickItemTo = "select";
          colorScheme = "carbonfox";
          lookAndFeel = "org.kde.breezedark.desktop";
          # theme = "breeze-dark";
        };

        hotkeys.commands."launch-kitty" = {
          name = "Launch Kitty";
          key = "Alt+Shift+T";
          command = "kitty";
        };

        panels = [
          {
            location = "top";
            height = 26;
            hiding = "dodgewindows";
            floating = true;
            widgets = [
              {
                kickoff = {
                  sortAlphabetically = true;
                  icon = "nix-snowflake-white";
                };
              }

              "org.kde.plasma.appmenu"

              "org.kde.plasma.panelspacer"

              {
                digitalClock = {
                  calendar.firstDayOfWeek = "monday";
                  date = {
                    enable = true;
                    position = "besideTime";
                    format.custom = "d MMM yyyy (yyyy-MM-dd)";
                  };

                  time.format = "24h";
                  timeZone = {
                    format = "code";
                    alwaysShow = true;
                  };
                };
              }

              "org.kde.plasma.panelspacer"

              {
                systemTray.items = {
                  # We explicitly show bluetooth and battery
                  shown = [
                    "org.kde.plasma.battery"
                    "org.kde.plasma.bluetooth"
                  ];
                  # And explicitly hide networkmanagement and volume
                  hidden =
                    [
                    ];
                };
              }

              "org.kde.plasma.pager"
            ];
          }
        ];

        configFile = {
          "baloofilerc"."Basic Settings"."Indexing-Enabled".value = false; # disable indexing
          "kdeglobals"."KDE"."AnimationDurationFactor" = 0.35;

          "krunnerrc" = {
            "General"."FreeFloating" = true;
            "Plugins/Favorites"."plugins" = "krunner_services";
          };

          "kwinrc" = {
            "Effect-overview" = {
              "BorderActivate" = 9;
              "GridBorderActivate" = 7;
            };

            "Plugins"."desktopchangeosdEnabled" = true;
            "Script-desktopchangeosd"."PopupHideDelay" = 750;

            "Effect-slide" = {
              "HorizontalGap" = 0;
              "VerticalGap" = 0;
            };
          };

        };

        shortcuts = {
          "kwin" = {

            "Grid View" = "Meta+Tab";

            "Window Maximize" = "Meta+Up";
            "Window Minimize" = "Meta+Down";
            "Window Close" = [
              "Meta+C"
              "Alt+F4"
            ];

            "Switch One Desktop Down" = [
              "Ctrl+Alt+Down"
              "Ctrl+Alt+S"
            ];
            "Switch One Desktop Up" = [
              "Ctrl+Alt+W"
              "Ctrl+Alt+Up"
            ];
            "Switch One Desktop to the Left" = [
              "Ctrl+Alt+A"
              "Ctrl+Alt+Left"
            ];
            "Switch One Desktop to the Right" = [
              "Ctrl+Alt+Right"
              "Ctrl+Alt+D"
            ];

            "Window One Desktop Down" = [
              "Ctrl+Alt+Shift+S"
              "Ctrl+Alt+Shift+Down"
            ];
            "Window One Desktop Up" = [
              "Ctrl+Alt+Shift+W"
              "Ctrl+Alt+Shift+Up"
            ];
            "Window One Desktop to the Left" = [
              "Ctrl+Alt+Shift+A"
              "Ctrl+Alt+Shift+Left"
            ];
            "Window One Desktop to the Right" = [
              "Ctrl+Alt+Shift+D"
              "Ctrl+Alt+Shift+Right"
            ];
          };
        };
      }
    else
      { };
}
