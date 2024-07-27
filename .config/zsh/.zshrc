# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -- ZINIT ---------------------------------------------------------------------

if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# -- PLUGINS -------------------------------------------------------------------

zinit ice depth=1
zinit light romkatv/powerlevel10k

zinit wait lucid light-mode for \
  ver="dev" \
  atload'bindkey "^u" dotbare-transform;
  bindkey "^d" dotbare-fedit' \
    kazhala/dotbare \
  https://raw.githubusercontent.com/aws/aws-cli/develop/bin/aws_zsh_completer.sh \
  atload'bindkey -M vicmd "k" history-substring-search-up;
  bindkey -M vicmd "j" history-substring-search-down' \
    zsh-users/zsh-history-substring-search \
  atload'_zsh_autosuggest_start;
  unset ZSH_AUTOSUGGEST_USE_ASYNC;
  bindkey -v "^ " autosuggest-accept' \
    zsh-users/zsh-autosuggestions \
  atinit'ZINIT[COMPINIT_OPTS]=-C;
  zicompinit;
  zicdreplay;
  complete -o nospace -C "$(which terraform)" terraform;
  eval "$(register-python-argcomplete pipx)"' \
  atload"FAST_HIGHLIGHT[chroma-man]=" \
    zdharma-continuum/fast-syntax-highlighting \
  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/autojump/autojump.plugin.zsh \
  MichaelAquilina/zsh-you-should-use \
  MichaelAquilina/zsh-auto-notify \
  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/dirhistory/dirhistory.plugin.zsh
  # chitoku-k/fzf-zsh-completions
  # MichaelAquilina/zsh-autoswitch-virtualenv \


# -- SETTINGS -----------------------------------------------------------------

# history
HISTSIZE=50000
SAVEHIST=10000
HISTFILE=~/.config/zsh/.zhistory

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

# completion
autoload -U colors && colors
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' \
  max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
expand-or-complete-with-dots() {
  [[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti rmam
  print -Pn "%{%F{red}......%f%}"
  [[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti smam

  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots
zmodload zsh/complist
LISTMAX=9999

# edit current line in vim
autoload -Uz edit-command-line
zle -N edit-command-line

# comments and process sub in propmt
setopt interactive_comments
setopt prompt_subst

# directory stack
setopt pushd_ignore_dups
setopt auto_pushd
setopt pushdminus

# misc
setopt nobeep
setopt ignoreeof


# -- ALIASES -------------------------------------------------------------------

alias vim="nvim"
alias cfg="config-edit"
alias k="kubectl"
alias cat="bat"
alias ..="cd .."
alias mv="mv -v"
alias cp="cp -v"
alias rm="rm -v"
alias tree="tree -I '.git|node_modules|bower_components|.DS_Store|build'"
alias hh="history -n | fzf --no-preview --bind 'enter:execute-silent(echo {+} | xclip -se c)+accept'"
alias tran="transmission-remote"
alias nerdctl="sudo nerdctl"
alias ls="ls --color=auto"

# -- SYSTEM ENV ----------------------------------------------------------------

export EDITOR="nvim"
export TERM="xterm-256color"
export COLORTERM="truecolor"
export BROWSER="brave"
export VAGRANT_HOME="$HOME/data/vagrant.d" 
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export PATH="$PATH:$HOME/.local/bin:`yarn global bin`:/usr/local/go/bin:$(ruby -e 'print Gem.user_dir')/bin:/usr/bin/google-cloud-sdk/bin:$HOME/go/bin:$HOME/.config/bin"

# you should use 
export YSU_MODE=ALL


# -- LESS ----------------------------------------------------------------------

export LESSHISTFILE=-
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# -- DOTBARE -------------------------------------------------------------------

export DOTBARE_DIR="$HOME/.cfg/"
export DOTBARE_TREE="$HOME"
export DOTBARE_BACKUP="${XDG_DATA_HOME:-$HOME/.local/share}/dotbare"
export DOTBARE_FZF_DEFAULT_OPTS="--preview-window=right:65%"
export DOTBARE_KEY="
  --bind=alt-a:toggle-all
  --bind=alt-w:jump
  --bind=alt-0:top
  --bind=alt-s:toggle-sort
  --bind=alt-t:toggle-preview
"


# -- FZF ----------------------------------------------------------------------

_gen_fzf_default_opts() {
local color00='#2E3440'
local color01='#3B4252'
local color02='#434C5E'
local color03='#4C566A'
local color04='#D8DEE9'
local color05='#E5E9F0'
local color06='#ECEFF4'
local color07='#8FBCBB'
local color08='#BF616A'
local color09='#D08770'
local color0A='#EBCB8B'
local color0B='#A3BE8C'
local color0C='#88C0D0'
local color0D='#81A1C1'
local color0E='#B48EAD'
local color0F='#5E81AC'

  # --color=bg+:$color00,bg:$color00,spinner:$color0C,hl:$color0D
  # --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
  # --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
  --height 50% --layout=reverse --border --cycle --info=inline
  --bind=ctrl-d:preview-page-down
  --bind=ctrl-u:preview-page-up
"
}
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
  --height 50% --layout=reverse --border --cycle --info=inline
  --bind=ctrl-d:preview-page-down
  --bind=ctrl-u:preview-page-up
"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# _gen_fzf_default_opts

export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_ALT_C_OPTS="--preview 'tree -L 1 -C --dirsfirst {} | head -200'"

# Use fd to generate auto completion
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'echo {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

# activate fzf keybindings
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
export FZF_COMPLETION_TRIGGER=''
export FZF_PREVIEW_COMMAND='bat {}'


fzf-man-widget() {
  batman="man {1} | col -bx | bat --language=man --plain --color always --theme=\"Monokai Extended\""
   man -k . | sort \
   | awk -v cyan=$(tput setaf 6) -v blue=$(tput setaf 4) -v res=$(tput sgr0) -v bld=$(tput bold) '{ $1=cyan bld $1; $2=res blue;} 1' \
   | fzf  \
      -q "$1" \
      --ansi \
      --tiebreak=begin \
      --prompt=' Man > '  \
      --preview-window '50%,rounded,<50(up,85%,border-bottom)' \
      --preview "${batman}" \
      --bind "enter:execute(man {1})" \
      --bind "alt-c:+change-preview(cht.sh {1})+change-prompt(ﯽ Cheat > )" \
      --bind "alt-m:+change-preview(${batman})+change-prompt( Man > )" \
      --bind "alt-t:+change-preview(tldr --color=always {1})+change-prompt(ﳁ TLDR > )"
  zle reset-prompt
}
# `Ctrl-H` keybinding to launch the widget (this widget works only on zsh, don't know how to do it on bash and fish (additionaly pressing`ctrl-backspace` will trigger the widget to be executed too because both share the same keycode)
bindkey '^h' fzf-man-widget
zle -N fzf-man-widget

# -- FUNCTIONS -----------------------------------------------------------------

KEYTIMEOUT=1
# change cursor shape in vi mode
zle-keymap-select () {
    if [[ $KEYMAP == vicmd ]]; then
        # the command mode for vi
        echo -ne "\e[2 q"
    else
        # the insert mode for vi
        echo -ne "\e[5 q"
    fi
}

precmd_functions+=(zle-keymap-select)
zle -N zle-keymap-select

take () {
  mkdir -p $@ && cd ${@:$#}
}

_run_fm() {
  fm
  BUFFER=
  zle accept-line
}

_run_ffd_d() {
  local result
  result="$(ffd --hidden --dir)"
  [[ -d "${result}" ]] && \
    cd "${result}"
  BUFFER=
  zle accept-line
}

pullhead () {
  git pull origin "$(git rev-parse --abbrev-ref HEAD)"
}

pushhead() {
  git push origin "$(git rev-parse --abbrev-ref HEAD)" -u
}

# -- KEYBINDING ----------------------------------------------------------------

bindkey -v

# ci", ci', ci`, di", etc
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect '^o' accept-and-infer-next-history

bindkey -M vicmd v edit-command-line
bindkey "^?" backward-delete-char

bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion

zle -N fm-invoke _run_fm
bindkey "^g" fm-invoke

zle -N ffd-d-invoke _run_ffd_d
bindkey "\ed" ffd-d-invoke

bindkey "^[[H"  beginning-of-line # home key + FN

bindkey -s '^o' 'ranger .^M'

bindkey -M vicmd '^R' fzf-history-widget

# bindkey '^[[A' up-line-or-search # search history with arrows
# bindkey '^[[B' down-line-or-search
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward
# -- FINAL ---------------------------------------------------------------------

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

. ~/.cache/wal/colors.sh
xrdb -merge ~/.cache/wal/colors.Xresources
