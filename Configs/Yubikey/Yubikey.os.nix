{
  pkgs,
  ...
}:
{
  security.pam.u2f = {
    settings = {
      authfile = ./u2f_authfile;
      cue = true;
      appid = "pam";
      origin = "pam";
    };
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    polkit-1.u2fAuth = true;
    su.u2fAuth = true;
    sddm.u2fAuth = true;
    kde.u2fAuth = true;
    systemd-run0.u2fAuth = true;

  };

  # polkit 127 sandboxed polkit-agent-helper@.service with PrivateDevices=yes +
  # DevicePolicy=strict (DeviceAllow only /dev/null), so pam_u2f in the polkit-1
  # stack can't open the Yubikey's /dev/hidraw* in ANY agent (DMS, terminal).
  # Same drop-in as Arch's packaging fix: allow hidraw + urandom.
  systemd.services."polkit-agent-helper@" = {
    serviceConfig = {
      PrivateDevices = false;
      DeviceAllow = [
        "/dev/urandom r"
        "char-hidraw rw"
      ];
    };
  };

  # FIXME: Creates problems with keepassxc
  # services.udev.extraRules = ''
  #   ACTION=="remove",\
  #    ENV{ID_BUS}=="usb",\
  #    ENV{ID_MODEL_ID}=="0407",\
  #    ENV{ID_VENDOR_ID}=="1050",\
  #    ENV{ID_VENDOR}=="Yubico",\
  #    RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  # '';
}
