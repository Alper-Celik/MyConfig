final: prev: {
  grapejuice =
    prev.grapejuice.override { wine = prev.wineWowPackages.stagingFull; };
}
