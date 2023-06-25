{ config, lib, pkgs, ... }: {
  # default wayland
  # services.xserver.displayManager.defaultSession = "plasmawayland";
  # services.xserver.displayManager.sddm.enable = true;
  # services.greetd = {
  #   enable = true;
  #   settings.default_session.command = "${pkgs.dbus}/bin/dbus-run-session env XKB_DEFAULT_LAYOUT=tr ${lib.getExe pkgs.cage} -s -mlast -- ${lib.getExe pkgs.st} -- ${lib.getExe pkgs.greetd.tuigreet} --remember --remember-session --asterisks --time -s $XDG_DATA_DIRS";
  # };

  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.displayManager.gdm.enable = true;
}
