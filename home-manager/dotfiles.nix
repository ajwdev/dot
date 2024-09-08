{
  pkgs,
  config,
# lib,
  ...
}:
let
  repoRoot = "${config.home.homeDirectory}/dot";
  dotfiles = "../dotfiles";

  alacrittyTheme = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/aarowill/base16-alacritty/c9e824811eed70d7cdb1b31614b81c2f82bf16f8/colors/base16-eighties.toml";
    hash = "sha256-JuTdsi5VLA2HM5RH7+E/I/QCC7BlR1s4H0jGEYsAG00=";
  };
in
{
  xdg.configFile."alacritty/alacritty.toml".source = ../dotfiles/alacritty/alacritty.toml;
  xdg.configFile."alacritty/base16-eighties.toml".source = alacrittyTheme;

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

  # Shell scripts
  home.file."bin/git-cowt".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/bin/git-cowt";
  home.file."bin/git-wip".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/bin/git-wip";
  home.file."bin/git-fx".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/bin/git-fx";
}
