{ pkgs, nightlyNvim, ... }:
let
  neovimRuntimeDependencies = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies";
    paths = with pkgs; [
      # For building plugins that need it (Telescope, Treesitter, etc)
      clang
      gnumake
      pandoc
      nodejs
      unstable.tree-sitter

      # Common language servers. Language specific ones should be installed
      # elsewhere (ex: project specific flake)
      unstable.bash-language-server
      lua-language-server
      nil # nix lsp
      nixfmt-rfc-style
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
