inputs: final: prev: {
  # DMS 1.6.2 declares `controlCenterWidget` on plugin components but never renders it, so a
  # plugin's Control Center entry can only be a pill with a detail drawer. The patch makes the
  # Control Center render the plugin-provided row, which the display-scale slider uses to sit
  # inline like the volume bar.
  #
  # nixpkgs builds dms-shell with sourceRoot = <src>/core and its preBuild runs `make sync-shell`,
  # which copies the sibling ../quickshell tree into the Go module — so the QML lives outside
  # sourceRoot and the patch has to be applied from the source root's parent.
  dms-shell = prev.dms-shell.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      # The fetched tree is read-only, and preBuild does the same chmod before syncing.
      chmod -R u+w ../quickshell
      patch -p1 -d .. < ${./dms-shell-control-center-widget.patch}
    '';
  });
}
