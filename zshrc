DIRSTACKSIZE=5
HISTSIZE=4000
SAVEHIST=4000
HISTFILE=~/.history

bindkey -e

setopt APPEND_HISTORY     # Append to history file instead of overwriting
setopt EXTENDED_HISTORY   # Save timestamps in history
setopt HIST_IGNORE_DUPS   # Dont save command in history if its a duplicate of the previous command
setopt HIST_NO_STORE      # don't save history cmd in history

setopt AUTO_CD            # cd if no matching command
setopt AUTOPUSHD          # Turn cd into pushd for all situations 
setopt PUSHD_IGNORE_DUPS  # Don't push multiple copies of the same directory onto the directory stack
setopt EXTENDED_GLOB 
setopt NUMERIC_GLOB_SORT  # Sort numerically first, before alpha
setopt NOMATCH            # Raise error if a glob did not match files instead passing that string back as an argument
setopt PRINT_EXIT_VALUE   # Print status code on non-zero returns
setopt MULTIOS            # Allow multiple redirection operators
setopt CORRECT           # Try to correct the spelling of commands
#setopt CORRECT_ALL        # Try to correct the spelling of all arguments in a line
setopt LIST_TYPES         # Show file types in list

# XXX Not sure about these yet
setopt PROMPT_SUBST
setopt PROMPT_PERCENT
#setopt HASH_CMDS # save cmd location to skip PATH lookup

unsetopt BEEP NOTIFY

autoload -U select-word-style
select-word-style bash

zmodload zsh/complist
autoload -Uz compinit
compinit

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:manuals' separate-sections true

# Set any special aliases
source ~/.gnu_aliases.sh
`uname -s`_aliases

alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias knife='nocorrect /opt/chefdk/bin/knife'
alias kitchen='nocorrect /opt/chefdk/bin/kitchen'
alias chef='nocorrect /opt/chefdk/bin/chef'
alias rspec='nocorrect rspec'
alias ls='ls -G'
alias ll='ls -lh'
alias la='ls -lha'
alias bex='nocorrect bundle exec'
alias less='less -R'  # Send raw ascii control codes (ex: colors)

alias ..='pushd ..'
alias ....='pushd ../..'
alias ......='pushd ../../..'

alias gh="open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\`"

# If MacVim is installed, use that binary
# Prioritize version in home directory if possible
if [ -f "$HOME/Applications/MacVim.app/Contents/MacOS/Vim" ]; then
    alias vim="nocorrect $HOME/Applications/MacVim.app/Contents/MacOS/Vim"
elif [ -f "/Applications/MacVim.app/Contents/MacOS/Vim" ]; then
    alias vim="nocorrect /Applications/MacVim.app/Contents/MacOS/Vim"
fi
export EDITOR="vim"

export WORKUSER='awilliams'

function hop() {
  ssh -Xat $WORKUSER@hop.intoxitrack.net
}

function gethostbyname() {
    python -c "import socket; print socket.gethostbyname('${1}')"
}

function webserver {
    port="${1:-3000}"
    ruby -r webrick -e "s = WEBrick::HTTPServer.new(:Port => $port, :DocumentRoot => Dir.pwd); trap('INT') { s.shutdown }; s.start"
}

function clear-chef-vendor {
  for b in $(git branch | egrep 'chef-vendor-.+'); do git branch -D $b; done
}

function remote-chef {
  knife ssh -a cloud.public_ipv4 -x awilliams "name:${1}" 'sudo sv 1 /service/chef-client && tail -F /service/chef-client/log/main/current'
}

function chef-whois {
  if [ -z "${1}" ]; then
    echo "Please specify an IP address" >&2
    return 1
  fi
  knife search "ipaddress:${1} or cloud_public_ipv4:${1} or cloud_local_ipv4:${1}"
}

function errno {
  cpp -dM /usr/include/errno.h | grep 'define E' | sort -n -k 3
}


# Nodejs
export PATH=/usr/local/share/npm/bin:$PATH

autoload -Uz promptinit
promptinit

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' actionformats '(%F{2}%b%F{3}|%F{1}%a%f)'
zstyle ':vcs_info:*' formats       '(%F{2}%b%f)'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
precmd () { vcs_info }

[ $UID != 0 ] && PS1=$'[%{\e[1;32m%}%n:%l %{\e[1;34m%}%2~%{\e[00m%}]${vcs_info_msg_0_}$ '

#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
#export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"

# Amazon EC2 command line
export JAVA_HOME="$(/usr/libexec/java_home)"
export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.7.1.0/libexec"
export EC2_AMITOOL_HOME="/usr/local/Cellar/ec2-ami-tools/1.5.3/libexec"

# The next line updates PATH for the Google Cloud SDK.
source '/Users/andrew/google-cloud-sdk/path.zsh.inc'
#
# # The next line enables bash completion for gcloud.
source '/Users/andrew/google-cloud-sdk/completion.zsh.inc'

# Aws completion
source /usr/local/share/zsh/site-functions/_aws
