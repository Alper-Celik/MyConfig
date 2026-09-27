{ config, lib, ... }:
{
  programs.mangohud = lib.mkIf (!config.x-headless) {
    enable = true;
    settings = {
      preset = -1;
      gpu_temp = true;
      cpu_temp = true;
      font_size = lib.mkForce 15;
      frame_timing = false;
    };
  };
}
