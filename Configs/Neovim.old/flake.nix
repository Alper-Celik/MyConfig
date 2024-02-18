{
  inputs =
    { };
  outputs = inputs:
    let
      nvim-plugins = inputs;

    in
    {
      overlays.default = (final: prev: {
        otherNeovimPlugins = (builtins.mapAttrs
          (name: value: final.pkgs.vimUtils.buildVimPluginFrom2Nix
            {
              src = value;
              name = name;
            })
          nvim-plugins) // {
          # telescope-fzf-native-nvim = final.pkgs.vimPlugins.telescope-fzf-native-nvim;
          treesitter = final.pkgs.vimPlugins.nvim-treesitter.withPlugins
            (p: with p;
            [
              bibtex
              latex
              #
              #     bash
              #     fish
              #     lua
              #     vim
              #     nix
              #     haskell
              #     terraform
              #
              #     regex
              #     markdown
              #     markdown_inline
              #     rst
              #
              #     c
              #     cpp
              #     cmake
              #     make
              #     ninja
              #     c_sharp
              #     qmljs
              #     rust
              #
              #     llvm
              #     cuda
              #
              #     css
              #     scss
              #     html
              #     javascript
              #     jsdoc
              #     tsx
              #     typescript
              #
              #     json
              #     toml
              #     yaml
              #
              #     htmldjango
              #     dart
              #     sql
              #
              #     diff
              #     git_rebase
              #     gitattributes
              #     gitcommit
              #     gitignore
              #
              #     ruby
              #     go
              #     gomod
              #     julia
              #     kotlin
              #     java
              #     scala
              #
              #     glsl
              #     hlsl
              #     wgsl
              #     wgsl_bevy
              #
              #     capnp
              #     proto
              #     dockerfile
              #
              #     dot
            ]);

        };
      });
    };
}
