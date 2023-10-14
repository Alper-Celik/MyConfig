{ lib, my-lib }: {

  getConfigs = { removed-files, suffixes ? [ ], base-dir, extension ? ".nix" }:
    with  builtins; let
      allowed-files-endings = map (x: x + extension) suffixes;


      all-inodes = removeAttrs (readDir base-dir) removed-files;

      flat-files = lib.filterAttrs (_: inode-type: inode-type == "regular") all-inodes;
      filtered-flat-file-names =
        filter (x: my-lib.endsWithAny x allowed-files-endings) (attrNames flat-files);
      filtered-flat-files = map (f: /${base-dir}/${f}) filtered-flat-file-names;

      all-dirs = lib.filterAttrs (_: inode-type: inode-type == "directory") all-inodes;
      filtered-dir-files =
        let
          variats-of-ends = dir-name:
            map (file-ending: /${base-dir}/${dir-name}/${dir-name}${file-ending}) allowed-files-endings;
          list-of-lists = map (f: variats-of-ends f) (attrNames all-dirs);
        in
        my-lib.flattenListOfLists list-of-lists;
      filtered-dir-files' = filter (f: pathExists f) (filtered-dir-files);
      filtered-nix-files = filtered-dir-files' ++ filtered-flat-files;

    in
    (
      filtered-nix-files ++ [ ]
    );

  maybeOutOfStore = configDir-attr: current-dir: file:
    if builtins.hasAttr "configDir" configDir-attr
    then "${configDir-attr.configDir}/${current-dir}/${file}"
    else ./${file};

}
