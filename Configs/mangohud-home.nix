{ ... }:
{
  programs.mangohud = {
    enable = true;
    settings = {
      preset = -1;
      gpu_temp = true;
      cpu_temp = true;
      font_size = 15;
      frame_timing = false;
    };
  };
}
