{ lib, ... }:
{
  # # Jovian's autoStart owns the display manager (SDDM + gamescope session).
  # services.displayManager.gdm.enable = lib.mkForce false;
  services.displayManager.defaultSession = lib.mkForce "gamescope-wayland";
  services.displayManager.autoLogin = {
    user = "alper";
    enable = true;
  };
}
