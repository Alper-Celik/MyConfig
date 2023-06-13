with import <nixpkgs> { };
mkShell {
  buildInputs = ((import ./python-pkgs.nix) python311Packages) ++ [ python311Packages.qtile ];
}
