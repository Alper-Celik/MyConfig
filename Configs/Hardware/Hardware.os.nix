{ pkgs-unstable, system, ... }:
let
  scx = pkgs-unstable.scx.rustscheds;
in

{
  services.tlp.enable = false;
  services.tuned.enable = true;
  environment.systemPackages = [ scx ];
  systemd.services.scx = {
    enable = system == "x86_64-linux";
    description = "SCX scheduler daemon";

    # SCX service should be started only if the kernel supports sched-ext
    unitConfig.ConditionPathIsDirectory = "/sys/kernel/sched_ext";

    startLimitIntervalSec = 30;
    startLimitBurst = 2;

    serviceConfig = {
      Type = "simple";
      ExecStart = "${scx}/bin/scx_cake";
      Restart = "on-failure";
    };
    wantedBy = [ "multi-user.target" ];
  };

  hardware.keyboard.qmk = {
    enable = true;
    keychronSupport = true;
  };
}
