{ inputs, pkgs, ... }: {
  imports = [
    inputs.dms-plugin-registry.nixosModules.default
    inputs.dankcalendar.nixosModules.default
  ];
  programs.dank-calendar = {
    enable = true;
    systemd.enable = true;
  };
  environment.systemPackages = with pkgs; [
    inotify-tools
    qrencode
    zbar
    tesseract
    img2pdf

    pulseaudio # for pactl for bluetooth codec changing in dms
  ];

  programs.dms-shell = {
    enable = true;
    systemd.enable = true;
    systemd.restartIfChanged = true;
    plugins = {
      wallpaperBing.enable = true;
      dankKDEConnect.enable = true;
      wallpaperCarousel.enable = true;
      qrGenerator.enable = true;
      dankscale.enable = true;
      kaomojiPicker.enable = true;
      emojiLauncher.enable = true;
      dankCalendarAgenda.enable = true;
    };
  };
}
