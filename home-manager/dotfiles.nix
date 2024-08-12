{
  config,
# lib,
  ...
}:
let
  repoRoot = "${config.home.homeDirectory}/dot";
in
{
  xdg.configFile."alacritty/alacritty.toml".source = ../dotfiles/alacritty/alacritty.toml;

  home.file = {
    ".ssh/config".source = ../dotfiles/ssh/config;
    ".zshrc".source = ../dotfiles/zsh/zshrc;
    ".zshenv".source = ../dotfiles/zsh/zshenv;
    ".tmux.conf".source = ../dotfiles/tmux.conf;
    ".screenrc".source = ../dotfiles/screenrc;
    ".gitconfig".source = ../dotfiles/git/gitconfig;
    ".gitignore_global".source = ../dotfiles/git/gitignore_global;

    ".gdbinit".text = ''
      set auto-load safe-path /nix/store
    '';
  };

  # Symlink directly to the nvim directory in our repo vs into a nix
  # derivation in the nix store.
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/dotfiles/nvim";
}
