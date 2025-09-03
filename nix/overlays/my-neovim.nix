{ pkgs, nightlyNvim, ... }:
let
  neovimRuntimeDependencies = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies";
    paths = with pkgs; [
      # For building plugins that need it (Telescope, Treesitter, etc)
      fzf
      clang
      gnumake
      pandoc
      nodejs
      tree-sitter

      # Common language servers. Language specific ones should be installed
      # elsewhere (ex: project specific flake)
      bash-language-server
      lua-language-server
      clang-tools
      nil # nix lsp
      nixfmt-rfc-style
      nodePackages.yaml-language-server
    ];
  };

  myNeovimUnwrapped = pkgs.wrapNeovim nightlyNvim {
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
