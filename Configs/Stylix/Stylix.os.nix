{ ... }:
{
  imports = [ ./Stylix-generic.nix ];
  stylix.targets.plymouth.enable = true;
  stylix.targets.gtk.enable = false;
}
