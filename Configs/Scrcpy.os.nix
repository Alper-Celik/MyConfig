{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    scrcpy
    v4l-utils
    android-tools
  ];
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
    extraModprobeConfig = "options v4l2loopback exclusive_caps=1 devices=3";
  };
  users.users.alper.extraGroups = [ "adbusers" ];
}
