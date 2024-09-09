{ lib, ... }:
{
  home.username = lib.mkDefault "alper";
  home.homeDirectory = lib.mkDefault "/home/alper";

}
