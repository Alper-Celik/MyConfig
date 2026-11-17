{
  config,
  specialArgs,
  my-lib,
  ...
}:
let
  current-dir = "Configs/Direnv";
  outOfStore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  # direnv sources every file in ~/.config/direnv/lib for each evaluation, so
  # this runs in every direnv-enabled project (and every worktree of one).
  xdg.configFile."direnv/lib/sccache.sh".source = outOfStore "sccache.sh";
}
