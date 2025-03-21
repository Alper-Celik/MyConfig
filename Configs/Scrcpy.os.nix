{ pkgs, config, ... }: {
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [ scrcpy v4l-utils ];
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
    extraModprobeConfig = "options v4l2loopback exclusive_caps=1 devices=3";
  };
  users.users.alper.extraGroups = [ "adbusers" ];
}
