export DOCKER_SCAN_SUGGEST=false
export ANSIBLE_NOCOWS=1
export BAT_THEME=OneHalfDark

if command -v nvim &>/dev/null; then
  export EDITOR=$(which nvim)
  alias vim=nvim
  export NVIMRC=$HOME/.config/nvim/init.lua
else
  export EDITOR=$(which vim)
fi

export PLAN9=$HOME/src/9fans/plan9port

[[ -d "/opt/homebrew/bin" ]]; then
  export PATH=/opt/homebrew/bin:$PATH
fi

# kubectl plugins
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Ruby
eval "$(rbenv init -)"
export PATH=$HOME/.rbenv/bin:$PATH

# Rust
source "$HOME/.cargo/env"

# Go
export GOPATH=$HOME

# Local settings typically for work stuff
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
