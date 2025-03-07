# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

# -----------------

export LANG=ja_JP.UTF-8

# ssh-agent as a plugin
plugins+=(git ssh-agent)

# XDG Configuratino for NeoVim
export XDG_CONFIG_HOME=$HOME/.config

## History
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

autoload colors
colors
limit coredumpsize 102400
unsetopt promptcr
setopt prompt_subst
setopt nobeep
setopt long_list_jobs
setopt list_types
setopt auto_resume
setopt auto_list
setopt list_packed
setopt hist_ignore_dups
setopt autopushd
setopt pushd_ignore_dups
setopt extended_glob
setopt auto_menu
setopt extended_history
setopt equals
setopt magic_equal_subst
setopt hist_verify
setopt numeric_glob_sort
setopt print_eight_bit
setopt share_history
setopt auto_cd
setopt auto_param_keys
setopt auto_param_slash
setopt correct
setopt noautoremoveslash

# 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1

# 補完候補の色づけ
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# sudo に対して環境変数 PATH を継承させる設定
alias sudo='sudo env PATH=$PATH'

# cdr
autoload -Uz is-at-least
if is-at-least 4.3.11
then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-max 5000
    zstyle ':chpwd:*' recent-dirs-default yes
    zstyle ':completion:*' recent-dirs-insert both
fi

## alias
setopt complete_aliases

case "${OSTYPE}" in
freebsd*|darwin*)
alias ls="ls -G -w"
;;
linux*)
alias ls="ls --color"
;;
esac
alias l="ls -lah"
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -lh"
alias du="du -h"
alias df="df -h"
alias duu="du -d 1"
alias v="nvim"
alias vimrc="nvim ~/.vimrc"
alias zshrc="nvim ~/.zshrc"
alias kickstart="nvim ~/.vim/lum/kickstart.lua"
alias tm="tmux a"
alias tmn="tmux new -s"
alias tig='tig --all'
alias t='tig --all'
alias gco="git checkout"
alias gst="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gdi="git diff"
alias gbr="git branch"
alias gpo="git push origin"
alias gpom="git push origin HEAD"
alias ds="docker ps"
alias stopemall="docker ps -q | xargs docker stop"
alias dockerkillall='docker kill $(docker ps -q)'
alias mv='mv -i'
alias cp='cp -i'

# cd && ll
cd() {
    builtin cd "$@"
}
cdls ()
{
    \cd "$@" && ls -lh
}
alias cd="cdls"

# diff
if type nvim 2>/dev/null 1>/dev/null; then
    alias diff='nvim -d'
fi

# bin/mcc
function _showMcc() {
    if [ -e ./mcc.yml ]; then
        exec < /dev/tty
        echo mcc
        mcc
    fi
    zle reset-prompt
}
zle -N showMcc _showMcc
bindkey '^N' showMcc
alias m='bin/mcc'

# ll
function doLL() {
    echo ll
    ls -l
    zle reset-prompt
}
zle -N doLL
bindkey '^L' doLL

# git status
function gitStatus() {
    echo gst
    gst
    zle reset-prompt
}
zle -N gitStatus
bindkey '^G' gitStatus

# soft_rm
function soft_rm()
{
    if [ ! -d /tmp/.trash ] ; then
        mkdir /tmp/.trash
    fi
    if [ ! -d /tmp/.trash/$USER ] ; then
        mkdir /tmp/.trash/$USER
    fi
    d="`date +%Y%m%d`"
    if [ ! -d /tmp/.trash/$USER/$d ] ; then
        mkdir /tmp/.trash/$USER/$d
    fi
    for file in $@
    do
        fn=$file
        fn2=${fn//\//___}
        fnf=`date '+%y%m%d%H%M%S'`
        fnc="${fnf}_${fn2}"
        mv $file /tmp/.trash/$USER/$d/$fnc

    done
}
alias rm="soft_rm"

# direnv
if command -v direnv > /dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# claude
alias claude="claude \"Check CLAUDE.md first\""

# ------------------------------
# Completion
# ------------------------------

zstyle ':completion:*:default' menu select=2

# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

# セパレータを設定する
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

# 名前で色を付けるようにする
autoload colors
colors

# LS_COLORSを設定しておく
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
