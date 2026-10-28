{
  # Units in the systemd *user* manager (session services, compositor helpers,
  # portals, ...) inherit systemd's DefaultTimeoutStopSec, which is 90 s in the
  # user manager. Cap it at 15 s so one stuck user unit cannot hold up a logout,
  # a session switch or a reboot for a minute and a half; units that genuinely
  # need longer can still set their own TimeoutStopSec.
  systemd.user.settings.Manager.DefaultTimeoutStopSec = "15s";

  # The graphical session (niri and everything it spawns) runs as a logind
  # session scope inside user.slice. Weighing that slice 5x over system.slice
  # keeps the desktop responsive while system work — nix-daemon, updatedb,
  # backups, sync — competes for the same cores and disk.
  systemd.slices."user".sliceConfig = {
    CPUWeight = 500;
    IOWeight = 500;
  };
}
