{
  pkgs ? import <nixpkgs> { },
}:
let
  neovimRuntimeDependencies = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies";
    paths = with pkgs; [
      lua-language-server
      clang
      gopls
      nil # nix lsp
    ];
  };
  # neovimRuntimeDependencies2 = pkgs.symlinkJoin {
  #   name = "neovimRuntimeDependencies2";
  #   paths = runtimeDeps.deps2;
  # };
  myNeovimUnwrapped = pkgs.wrapNeovim pkgs.neovim {
    # configure = {
    #   # inherit customRC;
    #   packages.all.start = plugins;
    # };
  };
in
pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = [ neovimRuntimeDependencies ];
  text = ''
    exec ${myNeovimUnwrapped}/bin/nvim "$@"
  '';
}
