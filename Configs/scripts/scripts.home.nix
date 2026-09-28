{
  config,
  lib,
  my-lib,
  specialArgs,
  ...
}:
let
  current-dir = "Configs/scripts";
  outOfStore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);

  # every regular (non-hidden, non-.nix) file in this folder is exposed on PATH
  # (XDG_BIN_HOME = $HOME/.local/bin, set in Configs/ProgramsCli) as a live symlink,
  # so edits here apply without a home-manager switch.
  scripts = builtins.attrNames (
    lib.filterAttrs (
      name: type:
      type == "regular" && !(lib.hasPrefix "." name) && !(lib.hasSuffix ".nix" name)
    ) (builtins.readDir ./.)
  );
in
{
  home.file = lib.listToAttrs (
    map (name: lib.nameValuePair ".local/bin/${name}" { source = outOfStore name; }) scripts
  );
}
