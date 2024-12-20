{ pkgs }:
let
  # customRC = import ../config { inherit pkgs; };
  # plugins = import ../plugins.nix { inherit pkgs; };
  # runtimeDeps = import ../runtimeDeps.nix { inherit pkgs; };
  neovimRuntimeDependencies = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies";
    paths = with pkgs; [
      clang
      nodePackages.typescript-language-server
    ];
  };
  myNeovimUnwrapped = pkgs.wrapNeovim pkgs.neovim {
    # configure = {
    #   inherit customRC;
    #   packages.all.start = plugins;
# };
  };
in
pkgs.writeShellApplication {
  name = "my-nvim";
  runtimeInputs = [
    neovimRuntimeDependencies
  ];
  text = ''
    ${myNeovimUnwrapped}/bin/nvim "$@"
  '';
}
