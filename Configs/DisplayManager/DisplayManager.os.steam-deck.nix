{ lib, config, ... }:
{
  services.displayManager.sddm.enable = lib.mkForce false;
  jovian.steam = {
    desktopSession = config.services.displayManager.defaultSession;
    autoStart = true;
    user = "alper";
  };
}
