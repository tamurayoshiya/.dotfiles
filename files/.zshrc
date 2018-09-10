# --------------------------------------------------------------
# --------------------- fundamental
# --------------------------------------------------------------

export LANG=ja_JP.UTF-8
export PATH="/usr/local/mysql/bin:/sbin:$PATH"

# oh-my-zsh
ZSH=$HOME/.oh-my-zsh
export DISABLE_AUTO_UPDATE="true"

if [ $HOST = 'dorm' ]; then
    #ZSH_THEME="af-magic"
    ZSH_THEME="lambda"
else
    #ZSH_THEME="minimal"
    #ZSH_THEME="lambda"
    #ZSH_THEME="wezm"
    ZSH_THEME="clean"
fi
pluigins=(git)
source $ZSH/oh-my-zsh.sh

# Add plugins
plugins+=(git ssh-agent)
# Z
source ~/.dotfiles/lib/z/z.sh
# XDG Configuratino for NeoVim
export XDG_CONFIG_HOME=$HOME/.config

# --------------------------------------------------------------
# --------------------- 一般設定
# --------------------------------------------------------------

## 履歴
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

# 補完機能の強化
autoload -U compinit
compinit -u
# プロンプトの設定
autoload colors
colors
# zmv
autoload -Uz zmv
alias zmv='noglob zmv -W'
# コアダンプサイズを制限
limit coredumpsize 102400
# 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr
# 色を使う
setopt prompt_subst
# ビープを鳴らさない
setopt nobeep
# 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs
# 補完候補一覧でファイルの種別をマーク表示
setopt list_types
# サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_resume
# 補完候補を一覧表示
setopt auto_list
# 補完候補を詰めて表示
setopt list_packed
# 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
# cd 時に自動で push
setopt autopushd
# 同じディレクトリを pushd しない
setopt pushd_ignore_dups
# ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob
# TAB で順に補完候補を切り替える
setopt auto_menu
# zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history
# =command を command のパス名に展開する
setopt equals
# --prefix=/usr などの = 以降も補完
setopt magic_equal_subst
# ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify
# ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort
# 出力時8ビットを通す
setopt print_eight_bit
# ヒストリを共有
setopt share_history
# ディレクトリ名だけで cd
setopt auto_cd
# カッコの対応などを自動的に補完
setopt auto_param_keys
# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# スペルチェック
setopt correct
# 最後のスラッシュを自動的に削除しない
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

# --------------------------------------------------------------
# --------------------- エイリアス
# --------------------------------------------------------------

## エイリアス - 一般
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

## エイリアス - vim
alias v="vim"

## エイリアス - tmux
alias tm="tmux a"
alias tmn="tmux new -s"
alias tig='tig --all'
alias t='tig --all'

## エイリアス - git
alias gco="git checkout"
alias gst="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gdi="git diff"
alias gbr="git branch"
alias gpo="git push origin"
alias gpom="git push origin master"

## 上書き確認

alias mv='mv -i'
alias cp='cp -i'

## git-archive-all
alias git-archive-all='~/.dotfiles/git-archive-all'

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

# ctags
if [ "$(uname)" = 'Darwin' ]; then
    alias ctags="`brew --prefix`/bin/ctags"
fi

# z.shで補完が効くように
compctl -U -K _z_zsh_tab_completion z

# --------------------------------------------------------------
# --------------------- 補完
# --------------------------------------------------------------

# dockerコマンド補完
dir=~/.dotfiles/lib/zsh-completions/
if [ -e $dir ]; then
    fpath=($dir $fpath)
    plugins+=(zsh-completions)
fi

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

# --------------------------------------------------------------
# --------------------- キーバインド
# --------------------------------------------------------------

# bin/mccスクリプトがある場合実行
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

# bin/menuスクリプトがある場合実行
alias m='bin/menu'

# ll を実行
function doLL() {
    echo ll
    ls -l
    zle reset-prompt
}
zle -N doLL
bindkey '^L' doLL

# git statusを実行
function gitStatus() {
    echo gst
    gst
    zle reset-prompt
}
zle -N gitStatus
bindkey '^G' gitStatus

# --------------------------------------------------------------
# --------------------- コマンド
# --------------------------------------------------------------

# rmコマンド実行時に、ファイルを削除するのではなく、
# /tmp/.trash/[user]ディレクトリに移動する
function soft_rm()
{
    # /tmp/.trashディレクトリがない場合作成
    if [ ! -d /tmp/.trash ] ; then
        mkdir /tmp/.trash
    fi
    # /tmp/.trashにユーザーのディレクトリがない場合作成
    if [ ! -d /tmp/.trash/$USER ] ; then
        mkdir /tmp/.trash/$USER
    fi
    # /tmp/.trash/[user]に日付のディレクトリがない場合作成
    d="`date +%Y%m%d`"
    if [ ! -d /tmp/.trash/$USER/$d ] ; then
        mkdir /tmp/.trash/$USER/$d
    fi
    # 引数のファイルを/tmp/.trash/[ユーザー名に移動]
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

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null 2>&1; then eval "$(rbenv init -)"; fi

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# direnv
eval "$(direnv hook zsh)"

# anyframe
if [ `which peco` ]; then
	fpath=($HOME/.zsh/anyframe(N-/) $fpath)
	autoload -Uz anyframe-init
	anyframe-init
fi
alias h=anyframe-widget-execute-history

