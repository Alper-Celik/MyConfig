{
  pkgs,
  ...
}:
{
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    polkit-1.u2fAuth = true;
    su.u2fAuth = true;
    sddm.u2fAuth = true;
    kde.u2fAuth = true;

  };

  services.udev.extraRules = ''
    ACTION=="remove",\
     ENV{ID_BUS}=="usb",\
     ENV{ID_MODEL_ID}=="0407",\
     ENV{ID_VENDOR_ID}=="1050",\
     ENV{ID_VENDOR}=="Yubico",\
     RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';
}
