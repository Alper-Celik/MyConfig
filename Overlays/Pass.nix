final: prev: {
  my-pass = prev.pass-wayland.withExtensions (exts: with exts;
    [
      pass-update
      pass-otp
      pass-import
      # pass-audit
    ]);
  passff-host = prev.passff-host.override { pass = final.my-pass; };
}
