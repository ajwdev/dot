# export ZPLUG_HOME=/usr/local/opt/zplug
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "rupa/z", use:z.sh
# Set the priority when loading
# e.g., zsh-syntax-highlighting must be loaded
# after executing compinit command and sourcing other plugins
# (If the defer tag is given 2 or above, run after compinit command)
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "plugins/urlutils", from:oh-my-zsh
zplug load

DIRSTACKSIZE=5
HISTSIZE=4000
SAVEHIST=4000
HISTFILE=~/.history

### Zsh options
# setopt APPEND_HISTORY    # Append to history file instead of overwriting
setopt INC_APPEND_HISTORY    # Append to history file instead of overwriting
setopt EXTENDED_HISTORY  # Save timestamps in history
setopt HIST_IGNORE_DUPS  # Dont save command in history if its a duplicate of the previous command
setopt HIST_NO_STORE     # Don't save history calls in history
setopt HIST_IGNORE_SPACE # Don't save commands with a leading space to history
setopt AUTO_CD           # cd if no matching command is found
setopt AUTOPUSHD         # Turn cd into pushd for all situations
setopt PUSHD_IGNORE_DUPS # Don't push multiple copies of the same directory onto the directory stack
setopt EXTENDED_GLOB
setopt NUMERIC_GLOB_SORT # Sort numerically first, before alpha
setopt NOMATCH           # Raise error if a glob did not match files instead passing that string back as an argument
setopt PRINT_EXIT_VALUE  # Print status code on non-zero returns
setopt MULTIOS           # Allow multiple redirection operators
setopt LIST_TYPES        # Show file types in list with trailing identifying mark
setopt PROMPT_SUBST      # Perform substitutions in prompt
setopt PROMPT_PERCENT    # Percents are special in prompts
setopt CORRECT           # Try to correct the spelling of commands

unsetopt CORRECT_ALL # Dont try and spelling check everything
unsetopt BEEP NOTIFY

# Disable shell flow control. Gives ctrl+s and ctrl+q back to the shell
which stty &>/dev/null
if [[ "$?" -eq 0 ]]; then
  stty -ixon
  setopt noflowcontrol
fi

### Zsh completions
fpath+=~/.zfunc
zmodload zsh/complist
autoload -Uz compinit && compinit

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' menu select
# Automatically update PATH entries
zstyle ':completion:*' rehash true
# Show message while waiting for completion
# XXX This ends up showing a blip of text everytime you tab complete :/
# zstyle ':completion:*' show-completer true
# Keep directories and files separated
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' verbose yes
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:manuals' separate-sections true


### Key bindings
bindkey -e  # Use Emacs bindings

# forward-word and backward-word should function like Bash
# where we move between path components instead of the entire path
autoload -Uz select-word-style
select-word-style bash

# This will open the current line in $EDITOR for advanced editing
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

zmodload zsh/deltochar
bindkey "\ez" zap-to-char

alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias knife='nocorrect /opt/chefdk/bin/knife'
alias kitchen='nocorrect /opt/chefdk/bin/kitchen'
alias chef='nocorrect /opt/chefdk/bin/chef'
alias rspec='nocorrect rspec'
alias l='ls -l'
alias ll='ls -lh'
alias la='ls -lha'
alias bex='nocorrect bundle exec'
alias less='less -R'  # Send raw ascii control codes (ex: colors)

alias -g ....='../..'
alias -g ......='../../..'

alias gtt='pushd $(git rev-parse --show-toplevel)'

if [[ "$(uname)" == "Darwin" ]]; then
  alias xargs=gxargs
  alias find=gfind
  alias tar=gtar
  alias awk='gawk'
  alias sed='gsed'
  alias airport=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport

  # If MacVim is installed, use that binary
  # Prioritize version in home directory if possible
  if [ -f "$HOME/Applications/MacVim.app/Contents/MacOS/Vim" ]; then
      alias vim="nocorrect $HOME/Applications/MacVim.app/Contents/MacOS/Vim"
  elif [ -f "/Applications/MacVim.app/Contents/MacOS/Vim" ]; then
      alias vim="nocorrect /Applications/MacVim.app/Contents/MacOS/Vim"
  fi

  function profile-userspace {
    if [ -z "${1}" ]; then
      echo "Please specify an application name" >&2
      return 1
    fi
    sudo dtrace -n "profile-97 /execname == \"${1}\"/ { @[ustack()] = count(); }"
  }

  function idea {
    open -a /Applications/IntelliJ\ IDEA\ CE.app/Contents/MacOS/idea "$@"
  }

  function j8 {
    export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
  }


  function notify {
    osascript -e "display notification 'Done: "$@"' with title '$@'"
  }

elif [[ "$(uname)" == "Linux" ]]; then
    alias open='xdg-open'

    function loopback-audio() {
        pactl unload-module module-loopback || true
        pactl load-module module-loopback
        # TODO How can determine if muted?
        pactl set-sink-mute 1 toggle
    }
fi

alias -g G='|& grep'
alias -g L='|& less'

alias cat=bat

for i in {1..9}; do
  alias a$i="awk '{print \$$i}'"
  alias -g A$i="| awk '{print \$$i}'"
done

# Shortcut for opening non-executable source
for ext in c cc S ld rs go js lua elm xml json yaml yml md; do
  alias -s $ext="$EDITOR"
done

alias -s git='git clone'
alias -s json='jq .'

# Kubernetes things
alias k=kubectl
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'
alias kgi='kubectl get ingress'

alias -g J='-o json'
alias -g Y='-o yaml'
alias -g W='-o wide'
alias -g N='-o name'

function github_url {
  git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e 's/:/\//' -e 's/git@/https:\/\//' -e 's/\.git$//'
}

function gh {
  open $(github_url)
}

function pr {
  open $(github_url)/pull/new/$(git rev-parse --abbrev-ref HEAD)
}

zmodload zsh/system

function gethostbyname() {
  if [ -z "${1}" ]; then
    echo "Please specify a hostname" >&2
    return 1
  fi

  python -c "import socket; print socket.gethostbyname('${1}')"
}

function webserver {
  port="${1:-3000}"
  ruby -r webrick -e "s = WEBrick::HTTPServer.new(Port: $port, DocumentRoot: Dir.pwd); trap('INT') { s.shutdown }; s.start"
}


# This functionality is replicated by syserror in zsh/system module
# function _errno {
#   cpp -dM /usr/include/errno.h | grep 'define E' | sort -n -k 3
# }
function utc {
  TZ=utc date
}

function t {
  echo "Local: $(date)"
  echo "UTC:   $(utc)"
  echo "Offset: $(date +"%Z %z")"
}


alias _join='ruby -e "puts STDIN.readlines.map(&:strip).join"'

function hex-to-bin {
  ruby -e "puts '%.8b' % ${1}"
}

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats       '(%F{2}%b%f%m)'
zstyle ':vcs_info:*' actionformats '(%F{2}%b%f%m|%F{1}%a%f)'
zstyle ':vcs_info:*+*:*' debug false
function +vi-git-stash() {
  git show-ref stash &>/dev/null
  if [[ "$?" -eq 0 ]]; then
    hook_com[misc]="|%F{orange}%BS%b%f"
  else
    hook_com[misc]=
  fi
}
zstyle ':vcs_info:git*+set-message:*' hooks git-stash
precmd () { vcs_info }


if [ -z $SSH_CLIENT ]; then
    [ $UID != 0 ] && PROMPT=$'[%{\e[1;32m%}%n:%l %{\e[1;34m%}%2~%{\e[00m%}]${vcs_info_msg_0_}%(1j.|%j|.)$ '
    # [ $UID != 0 ] && PROMPT=$'\U2029[%{\e[1;31m%}%n:%l %{\e[1;34m%}%2~%{\e[00m%}]${vcs_info_msg_0_}%(1j.|%j|.)$ \U2029'
else
  # Show hostname in SSH sessions
  [ $UID != 0 ] && PROMPT=$'[%{\e[1;32m%}%n@%m:%l %{\e[1;34m%}%2~%{\e[00m%}]${vcs_info_msg_0_}%(1j.|%j|.)$ '
fi

# GPG Agent stuff
export GPG_TTY=$(tty)
# unset SSH_AGENT_PID
# if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
#   export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
# fi

# export PATH=$HOME/.rbenv/bin:$PATH
# type rbenv &>/dev/null && eval "$(rbenv init -)"

# added by travis gem
[ -f /Users/awilliams/.travis/travis.sh ] && source /Users/awilliams/.travis/travis.sh


alias ensime="ctags -Re . & sbt clean ensimeConfig test:compile ensimeServerIndex"

function deployment-to-role {
  kubectl get deployments --all-namespaces -o json | \
    jq -r '.items[] | select(.spec.template.metadata.annotations."iam.amazonaws.com/role" != null) | "\(.metadata.name): \(.spec.template.metadata.annotations."iam.amazonaws.com/role")"'
}


function crow-dbg {
  curl -L -s ${1}/results.json | jq -r '.suitesFailed[] | .testsFailed[] | .testName'
}

function fh() {
  print -z $(fc -l 1 | fzf +s --tac | cut -d\  -f 4-)
}

function gosum-unmerge {
  if [ ! -f ./go.sum ]; then
    echo "go.sum not found" >&1
    return 1
  fi

  gsed -i -e '/<<<<<<</d' -e '/>>>>>>>/d' -e '/=======/d' ./go.sum
  go mod tidy
}

function kc {
  if [ ! -z "$1" ]; then
    RESULTS=$(find ~/.kube/ ~/.kube/tmp/ -maxdepth 1 -type f -exec basename {} \; | egrep -v '^config$' | sort | fzf -f $1)
  else
    RESULTS=$(find ~/.kube/ ~/.kube/tmp/ -maxdepth 1 -type f -exec basename {} \; | egrep -v '^config$' | sort | fzf)
  fi

  # if [[ $(echo $RESULTS | tr -d '[:space:]') -eq "" ]]; then
  #   echo "no matches found" >&2
  #   return 1
  # fi

  if [[ $(echo $RESULTS | wc -l) -ne 1 ]]; then
    echo "multiple matches:\n$RESULTS" >&2
    return 1
  fi

  eval "$(echo export KUBECONFIG=~/.kube/$RESULTS)"
  echo "Selected $RESULTS" >&2
  tm=$(kubectl config view --raw -o json | jq -r '.users[0].user."client-certificate-data" | @base64d' | openssl x509 -noout -text | awk -F' : ' '/Not After/ {print $2}')
  echo "Expires: $(gdate '+%b %d %H:%m:%S %Y %Z' -d $tm)" >&2
}

function kubeconfig {
  if [ -z $1 ]; then
    echo "must specify cluster name" >&1
    return 1
  fi

  $(kc bluemgmt && kubectl get secrets -n e880b8e1f1b61fadc821cba0510174165aca9bfa $1-kubeconfig J | jq -r '.data.value | @base64d' > ~/.kube/$1)
}

function kubeconfig-clean {
  ls -1 ~/.kube/tmp/
  rm ~/.kube/tmp/*
}


alias alsamixer='ssh -Xt andrew@192.168.1.86 alsamixer'

alias rgv='rg -g "!vendor"'
alias y2j='ruby -ryaml -rjson -e "YAML.load_stream(ARGF.file.read) { |x| puts x.to_json }"'

function acme() {
  PATH=$PLAN9/bin:$PATH $PLAN9/bin/acme
}

source $HOME/.zshrc.local

export DOCKER_SCAN_SUGGEST=false

function jwt {
  jq -R 'split(".") | .[0],.[1] | @base64d | fromjson'
}

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
