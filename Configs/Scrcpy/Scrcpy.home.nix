{ pkgs, pkgs-unstable, ... }:
let
  # adbutils: device list/props/hotplug; androguard: app label + launcher icon from APKs.
  python = pkgs-unstable.python3.withPackages (ps: [
    ps.adbutils
    ps.androguard
    ps.pillow
    ps.dbus-python
  ]);

  script = ./scrcpy-desktop;
in
{
  home.file.".local/bin/scrcpy-desktop" = {
    executable = true;
    text = ''
      #!${pkgs.runtimeShell}
      exec ${python}/bin/python3 ${script} "$@"
    '';
  };

  home.file.".local/bin/run-app" = {
    executable = true;
    text = ''
      #!${pkgs.runtimeShell}
      exec ${python}/bin/python3 ${script} run-app "$@"
    '';
  };

  systemd.user.services.scrcpy-desktop-entries = {
    Unit = {
      Description = "Generate .desktop entries for connected adb devices (scrcpy)";
      After = [ "default.target" ];
    };
    Service = {
      ExecStart = "%h/.local/bin/scrcpy-desktop watch";
      Restart = "always";
      RestartSec = 5;
      path = [
        pkgs-unstable.android-tools
        pkgs-unstable.scrcpy
        python
      ];
    };
    Install.WantedBy = [ "default.target" ];
  };
}
