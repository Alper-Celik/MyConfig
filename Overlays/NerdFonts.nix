final: prev: {
  nerdfonts = prev.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
  test = final.nerdfonts;
}
