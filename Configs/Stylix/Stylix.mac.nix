{
  lib,
  inputs,
  ...
}:
{
  # nix-darwin's stylix module injects the stylix home-manager module into
  # every home-manager user once stylix.enable is true, so the shared look
  # lives on the home-manager side here (see Stylix-generic.nix)
  stylix = {
    enable = true;
    # the system-side palette still needs a scheme; same source as generic
    base16Scheme = "${inputs.nightfox-nvim}/extra/carbonfox/base16.yaml";
  };

  home-manager.users.alper.imports = [ ./Stylix-generic.nix ];
}
