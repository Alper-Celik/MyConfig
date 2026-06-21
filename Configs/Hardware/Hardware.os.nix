{ pkgs-unstable, ... }:
let
  scx = pkgs-unstable.scx.full;
in
{
  powerManagement.cpuFreqGovernor = "performance";
  environment.systemPackages = [ scx ];
  systemd.services.scx = {
    description = "SCX scheduler daemon";

    # SCX service should be started only if the kernel supports sched-ext
    unitConfig.ConditionPathIsDirectory = "/sys/kernel/sched_ext";

    startLimitIntervalSec = 30;
    startLimitBurst = 2;

    serviceConfig = {
      Type = "simple";
      ExecStart = "${scx}/bin/scx_pandemonium --compositor niri";
      Restart = "on-failure";
    };
    wantedBy = [ "multi-user.target" ];
  };

  hardware.keyboard.qmk = {
    enable = true;
    keychronSupport = true;
  };
}
