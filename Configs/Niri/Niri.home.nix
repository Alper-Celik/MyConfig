{
  config,
  my-lib,
  specialArgs,
  ...
}:

let
  current-dir = "Configs/Niri";
  outOfStrore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  services.dunst = {
    enable = true;
  };
  services.hyprpolkitagent.enable = true;
  xdg.configFile."niri".source = outOfStrore ".";
  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
