export ANSIBLE_NOCOWS=1
export SVN_EDITOR=/usr/bin/vim
export GOPATH=$HOME/source/go

eval "$(rbenv init -)"
export PATH=$HOME/.rbenv/bin:$PATH

PLAN9=/usr/local/plan9port export PLAN9
# TODO Clean this up
PATH=/Users/andrew/bin:/opt/chefdk/bin:/usr/local/share/npm/bin:/usr/local/sbin:/usr/local/bin:$PATH:$GOPATH/bin:$HOME/.cargo/bin:$PLAN9/bin export PATH

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
