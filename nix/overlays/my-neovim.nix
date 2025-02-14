{ pkgs, nightlyNvim, ... }:
let
  neovimRuntimeDependencies = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies";
    paths = with pkgs; [
      # For building plugins that need it (Telescope, Treesitter, etc)
      clang
      gnumake
      nodejs
      unstable.tree-sitter

      rust-analyzer # TODO Can this be nightly?
      unstable.bash-language-server
      lua-language-server
      nil # nix lsp
      gopls
      ruby-lsp
      zls
      nodePackages.typescript-language-server
      nodePackages.yaml-language-server
    ];
  };

  myNeovimUnwrapped = pkgs.unstable.wrapNeovim nightlyNvim {
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
