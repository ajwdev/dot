{
  pkgs,
  config,
  ...
}:
let
  repoRoot = "${config.home.homeDirectory}/dot";

  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  template = import ./lib/template {
    inherit pkgs;
    lib = pkgs.lib;
  };
in
{
  home.file = {
    ".ssh/config".source = template.templateFile {
      src = ../dotfiles/ssh/config.template;
      config = {
        ssh = (config.dotfiles.ssh or { hosts = ""; });
      };
    };
    ".tmux.conf".source = ../dotfiles/tmux.conf;
    ".screenrc".source = ../dotfiles/screenrc;
    ".gitconfig".source = template.templateFile {
      src = ../dotfiles/git/gitconfig.template;
      config = {
        git = (config.dotfiles.git or { config = ""; });
      };
    };
    ".gitignore_global".source = ../dotfiles/git/gitignore_global;

    # zsh things
    ".zshenv".source = ../dotfiles/zsh/zshenv;
    ".zprofile".source = ../dotfiles/zsh/zprofile;
    ".zshrc".source = template.templateFile {
      src = ../dotfiles/zsh/zshrc.template;
      config = { }; # No config needed for zshrc
      buildTimeConfig = {
        ANTIDOTE_PKG = "${pkgs.antidote}/share/antidote/antidote.zsh";
      };
    };
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

    ".sqliterc".source = ../dotfiles/sqliterc;
    ".irbrc".source = ../dotfiles/irbrc;
  };

  # Symlink directly to the nvim directory in our repo vs into a nix
  # derivation in the nix store.
  home.file.".config/nvim".source = mkOutOfStoreSymlink "${repoRoot}/dotfiles/nvim";

  # Shell scripts
  home.file."bin/git-cowt".source = mkOutOfStoreSymlink "${repoRoot}/bin/git-cowt";
  home.file."bin/git-wip".source = mkOutOfStoreSymlink "${repoRoot}/bin/git-wip";
  home.file."bin/git-fx".source = mkOutOfStoreSymlink "${repoRoot}/bin/git-fx";
  home.file."bin/git-branch-gc".source = mkOutOfStoreSymlink "${repoRoot}/bin/git-branch-gc";
  home.file."bin/confrw".source = mkOutOfStoreSymlink "${repoRoot}/bin/confrw";
  home.file."bin/better-git-branch.sh".source =
    mkOutOfStoreSymlink "${repoRoot}/bin/better-git-branch.sh";
  home.file."bin/git-related-files.rb".source =
    mkOutOfStoreSymlink "${repoRoot}/bin/git-related-files.rb";
  home.file."bin/sort-path.sh".source = mkOutOfStoreSymlink "${repoRoot}/bin/sort-path.sh";
}
