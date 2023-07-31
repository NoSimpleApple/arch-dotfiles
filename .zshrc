# zinit module setup
# module_path+=( "/home/hoshino/.local/share/zinit/module/Src" )
# zmodload zdharma_continuum/zinit

##### zsh options #####
export HISTSIZE=30000
export SAVEHIST=20000
export HISTFILE=~/.zsh_history

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
#setopt EXTENDED_HISTORY
setopt EXTENDED_GLOB
setopt NO_BG_NICE
unsetopt beep

# custom action of ctrl-w to delete one word 
# autoload -U select-word-style
# select-word-style bash
export WORDCHARS='.-&$#!*_(){};'

export ZSH_COMPDUMP=$ZSH_CACHE_DIR/.zcompdump-$HOST

# bindkey -N hoshino_arch_zsh emacs
bindkey -e

# export XDG_CONFIG_HOME=$HOME/.config

# auto cd to $HOME
# cd $HOME
if [[ "$(id -un)" == 'root' ]] {
	cd $HOME
}

# env
export MANPATH="/usr/local/man:$MANPATH"
export PATH="$HOME/.local/bin:$PATH:$HOME/.bscripts"

# You may need to manually set your language environment
export LANG=zh_CN.UTF-8

# change preferred editor manually
export EDITOR=nvim

# lua runtime path
# export LUA_PATH="/home/${USER}/.config/nvim/?/init.lua;;"

#######User configuration######
#
# options of autocompletions
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

# path completions
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'
zstyle ':completion::complete:*' '\\'

# colored cmp menu
export ZLSCOLORS=$LS_COLORS
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# case correction
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# fuzzy match commands
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# make groups for each completions
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'

# autocompletions for kill command
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

# sorted completions for cd
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'


# compdef bindings
#
# completion for kitten hyperlinked_grep
# compdef _rg grepp

# zinit setup
source /usr/share/zinit/zinit.zsh

# create completions cache dir manually to prevent omz plugins from being confused
mkdir -p $ZSH_CACHE_DIR/completions

# install completions manually
{
    zinit ice as"completions" blockf
    zinit snippet https://github.com/bootandy/dust/blob/master/completions/_dust
}

# plugin starship setup
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship


# omz theme
 zinit snippet OMZL::git.zsh 
 zinit snippet OMZL::theme-and-appearance.zsh 
 zinit snippet OMZL::prompt_info_functions.zsh 
# zinit snippet OMZT::jonathan

# instant loading
zinit snippet OMZP::systemd
zinit snippet OMZP::archlinux
zinit snippet OMZP::fzf
zinit snippet OMZP::branch
zinit snippet OMZP::copybuffer
zinit snippet OMZP::wp-cli
zinit snippet OMZP::gitignore
zinit snippet OMZP::history
zinit snippet OMZP::python
# zinit snippet OMZP::pip
zinit snippet OMZP::sudo
zinit snippet OMZP::systemadmin
zinit snippet OMZP::virtualenv
zinit snippet OMZP::poetry
zinit snippet OMZP::extract
zinit snippet OMZP::zoxide

# loading time-comsuming plugins 
zinit wait lucid for \
        OMZP::colored-man-pages \
        OMZP::autoenv \
        OMZP::pyenv \
        MichaelAquilina/zsh-auto-notify \
        hlissner/zsh-autopair \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    blockf \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions 
    
# settings of zsh-auto-notify
export AUTO_NOTIFY_THRESHOLD=30
export AUTO_NOTIFY_EXPIRE_TIME=20000
export AUTO_NOTIFY_WHITELIST=("pacman" "yay" "pip" "gcc" "g++")
AUTO_NOTIFY_IGNORE+=("podman" "nvim" "vim" "fd" "find" "dust" "sleep" "man")

# fzf funcs
function rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

# fzf settings
# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'


##### aliases #####
alias open="xdg-open"
alias vi="nvim"
alias nvi="neovide"
alias ls="ls --hyperlink=auto --color=auto"
alias rm="rm -iv"
alias icat="kitty +kitten icat"
alias ssh="kitty +kitten ssh"
alias diff="kitty +kitten diff"
alias hlp="tldr"
alias l="exa -l"
alias transf="kitty +kitten transfer"

# alias grepp="kitty +kitten hyperlinked_grep"
alias ping="sudo -u clash ping -c 5"

####hooks####
eval "$(atuin init zsh)"

# find-the-command use pacman to manage with
source /usr/share/doc/find-the-command/ftc.zsh
