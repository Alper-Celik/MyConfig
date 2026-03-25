{ pkgs, pkgs-unstable, ... }:
{
  security.polkit.enable = true;
  services.graphical-desktop.enable = true;

  environment.systemPackages = with pkgs; [
    pkgs-unstable.niri
    xwayland-satellite

    playerctl
    brightnessctl
  ];

  programs.uwsm = {
    enable = true;
    waylandCompositors.niri = {
      prettyName = "Niri";
      binPath = "/run/current-system/sw/bin/niri";
    };
  };

  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  xdg.portal = {
    enable = true;

    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.FileChooser" = "kde";
    };

    # Recommended by upstream, required for screencast support
    # https://github.com/YaLTeR/niri/wiki/Important-Software#portals
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  systemd.tmpfiles.rules = [
    "L+ /etc/nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json - - - - ${pkgs.writeText "nvidia-niri-fix.xml" ''
      {
          "rules": [
              {
                  "pattern": {
                      "feature": "procname",
                      "matches": "niri"
                  },
                  "profile": "Limit Free Buffer Pool On Wayland Compositors"
              }
          ],
          "profiles": [
              {
                  "name": "Limit Free Buffer Pool On Wayland Compositors",
                  "settings": [
                      {
                          "key": "GLVidHeapReuseRatio",
                          "value": 0
                      }
                  ]
              }
          ]
      }
    ''}"
  ];
}
