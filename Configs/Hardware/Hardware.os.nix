{
  pkgs-unstable,
  system,
  hardware,
  lib,
  ...
}:
let
  scx = pkgs-unstable.scx.rustscheds;
in

{
  services.tlp.enable = false;
  services.tuned.enable = true;
  # Jovian owns the scx unit on the deck (services.scx).
  environment.systemPackages = lib.mkIf (hardware != "steamdeck") [ scx ];

  environment.persistence."/persistent".directories = [ "/var/lib/pandemonium/" ];
  systemd.services.scx = lib.mkIf (hardware != "steamdeck") {
    enable = system == "x86_64-linux";
    description = "SCX scheduler daemon";

    # SCX service should be started only if the kernel supports sched-ext
    unitConfig.ConditionPathIsDirectory = "/sys/kernel/sched_ext";

    startLimitIntervalSec = 30;
    startLimitBurst = 2;

    serviceConfig = {
      Type = "simple";
      ExecStart = "${scx}/bin/scx_pandemonium";
      Restart = "on-failure";
    };
    wantedBy = [ "multi-user.target" ];
  };

  hardware.keyboard.qmk = {
    enable = true;
    keychronSupport = true;
  };
}
