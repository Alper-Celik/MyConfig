final: prev: {
  my-pass = prev.pass-wayland.withExtensions (exts: with exts;
    [
      pass-update
      pass-otp
    ]);
  passff-host = prev.passff-host.override { pass = final.my-pass; };
}
