{
  pkgs,
  config,
  workDotfileArgs,
  ...
}:
let
  repoRoot = "${config.home.homeDirectory}/dot";

  alacrittyTheme = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/aarowill/base16-alacritty/c9e824811eed70d7cdb1b31614b81c2f82bf16f8/colors/base16-eighties.toml";
    hash = "sha256-JuTdsi5VLA2HM5RH7+E/I/QCC7BlR1s4H0jGEYsAG00=";
  };

  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  erbtemplate = import ./lib/erb pkgs;
in
{
  xdg.configFile."alacritty/alacritty.toml".source = ../dotfiles/alacritty/alacritty.toml;
  xdg.configFile."alacritty/base16-eighties.toml".source = alacrittyTheme;
  xdg.configFile."ghostty/config".source = ../dotfiles/ghostty/config;

  home.file = {
    ".ssh/config".source = mkOutOfStoreSymlink (
      erbtemplate ../dotfiles/ssh/config.erb "ssh-config" workDotfileArgs
    );
    ".tmux.conf".source = ../dotfiles/tmux.conf;
    ".screenrc".source = ../dotfiles/screenrc;
    ".gitconfig".source = mkOutOfStoreSymlink (
      erbtemplate ../dotfiles/git/gitconfig.erb "gitconfig" workDotfileArgs
    );
    ".gitignore_global".source = ../dotfiles/git/gitignore_global;

    # zsh things
    ".zshenv".source = ../dotfiles/zsh/zshenv;
    ".zprofile".source = ../dotfiles/zsh/zprofile;
    ".zshrc".source = erbtemplate ../dotfiles/zsh/zshrc.erb "zshrc" {
        antidote_pkg = pkgs.antidote;
    } // workDotfileArgs;
    ".zfunc".source = mkOutOfStoreSymlink "${repoRoot}/dotfiles/zsh/zfunc";
    ".zsh_plugins.txt".text = ''
      rupa/z
      zsh-users/zsh-syntax-highlighting kind:defer
      chisui/zsh-nix-shell path:nix-shell.plugin.zsh
      zsh-users/zsh-history-substring-search
    '';

    ".gdbinit".text = ''
      set auto-load safe-path /nix/store
    '';

    # Hides/accepts the academic citation notice
    ".parallel/will-cite".text = '''';
  };


  # Symlink directly to the nvim directory in our repo vs into a nix
  # derivation in the nix store.
  home.file.".config/nvim".source = mkOutOfStoreSymlink "${repoRoot}/dotfiles/nvim";

  # Shell scripts
  home.file."bin/git-cowt".source = mkOutOfStoreSymlink "${repoRoot}/bin/git-cowt";
  home.file."bin/git-wip".source = mkOutOfStoreSymlink "${repoRoot}/bin/git-wip";
  home.file."bin/git-fx".source = mkOutOfStoreSymlink "${repoRoot}/bin/git-fx";

}
