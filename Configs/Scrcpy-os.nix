{ pkgs, config, ... }:
{
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [
    scrcpy
    v4l-utils
  ];
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
  };
  users.users.alper.extraGroups = [ "adbusers" ];
}
