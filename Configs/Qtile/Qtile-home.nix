{ config, my-lib, specialArgs, ... }:
let
  current-dir = "Configs/Qtile";
  outOfStrore = x: config.lib.file.mkOutOfStoreSymlink
    (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{

  xdg.configFile."qtile".source = outOfStrore ".";
} 
