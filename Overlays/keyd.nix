inputs: final: prev: {
  keyd = prev.keyd.overrideAttrs (oldAttrs: {
    src = inputs.keyd;
  });

}
