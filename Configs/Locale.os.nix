{ ... }:
{
  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "C.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "trq";
    # useXkbContrg = true; # use xkbOptions in tty.
  };
  services.xserver.xkb.layout = "tr";

}
