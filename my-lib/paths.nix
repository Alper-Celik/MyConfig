{ lib, my-lib }: {

  getConfigs = removed-files: suffix: base-dir:
    with  builtins; let
      all-inodes = removeAttrs (readDir base-dir) removed-files;
      all-dirs = lib.filterAttrs (_: inode-type: inode-type == "directory") all-inodes;

      flat-files = lib.filterAttrs (_: inode-type: inode-type == "regular") all-inodes;
      filtered-flat-files = filter (x: my-lib.endsWith x suffix) (attrNames flat-files);

      filtered-dir-files = map (f: /${base-dir}/${f}/${f}${suffix}) (attrNames all-dirs);
      filtered-dir-files' = filter (f: pathExists f) filtered-dir-files;
      filtered-flat-files' = map (f: /${base-dir}/${f}) filtered-flat-files;
      filtered-nix-files = filtered-dir-files' ++ filtered-flat-files';

    in
    (
      filtered-nix-files
    );

  maybeOutOfStore = configDir-attr: current-dir: file:
    if builtins.hasAttr "configDir" configDir-attr
    then "${configDir-attr.configDir}/${current-dir}/${file}"
    else ./${file};

}
