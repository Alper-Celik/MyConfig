# nixpkgs' dtc-1.8 workaround (NixOS/nixpkgs#568745) rewrites
# -Wno-graph_child_address -> -Eno-node_name_not_empty in all u-boot builds.
# The asahi u-boot (nixos-apple-silicon) builds with its in-tree dtc, which
# does not know that check name, so the injected flag is fatal.
inputs: final: prev: {
  uboot-asahi = prev.uboot-asahi.overrideAttrs (o: {
    postPatch = (o.postPatch or "") + ''
      for f in scripts/Makefile.lib dts/upstream/Makefile; do
        substituteInPlace "$f" --replace-fail -Eno-node_name_not_empty -Wno-graph_child_address
      done
    '';
  });
}
