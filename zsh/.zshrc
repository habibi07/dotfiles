export ZSH="/home/habibi/.config/.oh-my-zsh"
export VAGRANT_HOME="$HOME/data/vagrant.d" 
export FONT="FantasqueSansMono Nerd Font"
export BROWSER="brave"
export EDITOR="nvim"
export VISUAL="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

#source ~/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh
PROMPT='%(!.%{%F{yellow}%}.)$USER @ %{$fg[white]%}%M %{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
# Autocomplete dla nvm - node version manager
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

ZSH_THEME="agnoster"
#ZSH_THEME="steeef"

# history setup
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

#plugins=(git archlinux colored-man-pages common-aliases docker docker-compose vagrant vagrant-prompt virtualenv zsh-interactive-cd zsh-navigation-tools zsh-autosuggestions fzf autojump)
plugins=(git archlinux colored-man-pages common-aliases docker docker-compose vagrant vagrant-prompt virtualenv zsh-interactive-cd zsh-navigation-tools zsh-autosuggestions fzf autojump zsh-syntax-highlighting)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=60"

source $ZSH/oh-my-zsh.sh

### Aliasy 
alias zshconfig="$EDITOR $ZDOTDIR/.zshrc"
alias awesomeconfig="$EDITOR $HOME/.config/awesome/rc.lua"
alias vimconf="$EDITOR $HOME/.config/nvim/init.vim"
alias cfg="config-edit"
alias vim="$EDITOR"


### ZNT's installer added snippet ###
fpath=( "$fpath[@]" "$HOME/.config/znt/zsh-navigation-tools" )
autoload n-aliases n-cd n-env n-functions n-history n-kill n-list n-list-draw n-list-input n-options n-panelize n-help
autoload znt-usetty-wrapper znt-history-widget znt-cd-widget znt-kill-widget
alias naliases=n-aliases ncd=n-cd nenv=n-env nfunctions=n-functions nhistory=n-history
alias nkill=n-kill noptions=n-options npanelize=n-panelize nhelp=n-help
alias cat=bat

zle -N znt-history-widget
bindkey '^R' znt-history-widget
setopt AUTO_PUSHD HIST_IGNORE_DUPS PUSHD_IGNORE_DUPS
zstyle ':completion::complete:n-kill::bits' matcher 'r:|=** l:|=*'
### END ###

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS="-m --height 50% --border --bind=alt-j:up,alt-k:down --no-preview"
  # export FZF_DEFAULT_OPTS="-m --height 50% --border --bind=alt-j:up,alt-k:down --preview 'bat --color=always --style=numbers --line-range=:500 {}' --theme='Dracula' "
fi

bindkey '^ ' autosuggest-accept
# export FZF_DEFAULT_OPTS="-m --height 50% --border --bind=alt-j:up,alt-k:down --preview 'bat --color=always --style=numbers --line-range=:500 {}' --theme='Dracula' " fi bindkey '^ ' autosuggest-accept

export GPG_TTY=$(tty)

### kubectl
source <(kubectl completion zsh)
source <(k3d completion zsh)
source <(kind completion zsh)
source <(helm completion zsh)
source <(k9s completion zsh)

alias k=kubectl
alias dps="docker ps -a"
alias hh="history -n | fzf --no-preview --bind 'enter:execute-silent(echo {+} | xclip -se c)+accept'"
alias tran="transmission-remote"
eval $(thefuck --alias)
complete -F __start_kubectl k

export PATH="$PATH:$HOME/.local/bin:`yarn global bin`:/usr/local/go/bin:$(ruby -e 'print Gem.user_dir')/bin:/usr/bin/google-cloud-sdk/bin"

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

archey3
colorscript -e 12

zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:*' fzf-completion yes

bindkey -s '^o' 'ranger .^M'
bindkey '^g' clear-screen
alias tor="transmission-remote"

# aws completion
complete -C '/usr/local/bin/aws_completer' aws

if [ -f '/usr/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/bin/google-cloud-sdk/completion.zsh.inc'; fi


source "/home/habibi/.sdkman/bin/sdkman-init.sh"

