#!/usr/bin/env zsh

# TODO Make this work on Linux
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

# Add syserror function for looking up standard error codes
zmodload zsh/system

# Git info in prompt
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

export GPG_TTY=$(tty)

# Use fzf for search history
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

# no spelling correction on some commands
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'

# I can't retrain my brain to use bat
if command -v bat &>/dev/null; then
  alias cat=bat
fi

alias ll='ls -lh'
alias la='ls -lha'
alias less='less -R'  # Send raw ascii control codes (ex: colors)

# Global and suffix aliases
alias -g ....='../..'
alias -g ......='../../..'
alias -g G='|& grep'
alias -g L='|& less'

# Shortcuts for printing a numbered column
# Ex: echo "foo bar baz" | c2
#   > bar
for i in {1..9}; do
  alias c$i="awk '{print \$$i}'"
  alias -g C$i="| awk '{print \$$i}'"
done

# Shortcut for opening non-executable source
for ext in c cc S ld rs go js lua elm xml json yaml yml; do
  alias -s $ext="$EDITOR"
done

if command -v mdcat &>/dev/null; then
  alias -s md=mdcat
fi
alias -s git='git clone'
alias -s json='jq .'

alias cdroot='pushd $(git rev-parse --show-toplevel)'

function github_url {
  git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e 's/:/\//' -e 's/git@/https:\/\//' -e 's/\.git$//'
}

function pr {
  open $(github_url)/pull/new/$(git rev-parse --abbrev-ref HEAD)
}


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

function utc {
  TZ=utc date
}

alias now="when 'now in utc -> stl'"

alias _join='ruby -e "puts STDIN.readlines.map(&:strip).join"'

function hex-to-bin {
  ruby -e "puts '%.8b' % ${1}"
}

function gosum-unmerge {
  if [ ! -f ./go.sum ]; then
    echo "go.sum not found" >&1
    return 1
  fi

  gsed -i -e '/<<<<<<</d' -e '/>>>>>>>/d' -e '/=======/d' ./go.sum
  go mod tidy
}

# Kubernetes things
alias k=kubectl
alias kar='kubectl api-resources'

# This are designed for kubernetes but end up working with other commands
alias -g J='-o json'
alias -g Y='-o yaml'
alias -g W='-o wide'
alias -g N='-o name'

function kc() {
	result=$(kubectl config get-contexts -o name | fzf-tmux -p \
        --info=inline --layout=reverse --header-lines=1  \
        --prompt "Current: '$(kubectl config current-context)'> " \
        --header "╱ Enter (select context) ╱ CTRL-X (run one-off command with context)\n\n" \
        --preview-window up:follow \
        --preview="$HOME/bin/libexec/fzf_kube_preview.sh {}" \
        # --bind 'ctrl-x:execute:kubectl logs --all-containers --namespace {1} {2}) > /dev/tty' \
      ) 
	if [ ! -z $result ]
	then
		kubectl config use-context $result
	fi
}

function acme() {
  PATH=$PLAN9/bin:$PATH $PLAN9/bin/acme
}

alias y2j='ruby -ryaml -rjson -e "YAML.load_stream(ARGF.file.read) { |x| puts x.to_json }"'

function jwt {
  jq -R 'split(".") | .[0],.[1] | @base64d | fromjson'
}

if [[ "$(uname)" == "Darwin" ]]; then
  # Prefer gnu userland
  alias xargs=gxargs
  alias find=gfind
  alias tar=gtar
  alias awk=gawk
  alias sed=gsed

  alias airport=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport
fi

# Local changes mostly for work stuff
[[ -f "$HOME/.zshrc.local" ]] && source $HOME/.zshrc.local
