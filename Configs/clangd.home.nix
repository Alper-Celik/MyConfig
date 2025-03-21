{ ... }: {
  xdg.configFile."clangd/config.yaml".text = ''
    CompileFlags:
        CompilationDatabase: build/
  '';
}
