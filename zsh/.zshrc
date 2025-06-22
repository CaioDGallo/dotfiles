# User configuration

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
	docker
)

source $ZSH/oh-my-zsh.sh

HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000
setopt appendhistory

#Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

alias setup-caio-repo="git config user.name \"Caio Gallo\" && git config user.email \"caiogallo88@gmail.com\""

alias yp-prod="echo \"password: 2022!.Easy\" && ssh root@209.97.134.21"
alias vim="nvim"
alias ovim="vim"
alias lzd="lazydocker"
alias postman="nohup /home/caiogallo/Documents/Postman/Postman &> /dev/null &"
alias nconf="cd ~/.config/nvim && nvim ."

alias brgt1="xrandr --output eDP-1 --brightness 1 && xrandr --output HDMI-1-1 --brightness 1"
alias brgt2="xrandr --output eDP-1 --brightness 0.2 && xrandr --output HDMI-1-1 --brightness 0.2"
alias brgt3="xrandr --output eDP-1 --brightness 0.3 && xrandr --output HDMI-1-1 --brightness 0.3"
alias brgt4="xrandr --output eDP-1 --brightness 0.4 && xrandr --output HDMI-1-1 --brightness 0.4"
alias brgt5="xrandr --output eDP-1 --brightness 0.5 && xrandr --output HDMI-1-1 --brightness 0.5"
alias brgt6="xrandr --output eDP-1 --brightness 0.6 && xrandr --output HDMI-1-1 --brightness 0.6"
alias brgt7="xrandr --output eDP-1 --brightness 0.7 && xrandr --output HDMI-1-1 --brightness 0.7"
alias brgt8="xrandr --output eDP-1 --brightness 0.8 && xrandr --output HDMI-1-1 --brightness 0.8"
alias brgt8="xrandr --output eDP-1 --brightness 0.9 && xrandr --output HDMI-1-1 --brightness 0.9"

alias pause-notifications="killall -SIGUSR1 dunst"
alias resume-notifications="killall -SIGUSR2 dunst"

alias diskbd="xinput float 17"
alias rekbd="xinput reattach 17 3"

alias notes="cd ~/projects/caio-notes && nvim ."

alias dpp="docker ps --format '{{.ID}} - {{.Image}} - {{.Status}} - {{.Names}}'"
alias tmn="tmux new -s"
alias tma="tmux new-session -A -s"
alias tms="tmux switch -t"
alias tml="tmux ls"
alias tmx="tmuxinator start"
alias tmk="tmux kill-server"
alias tmp="tmuxp load"

alias ll="eza --git -l -g --icons --group-directories-first --all"
alias cat="bat"
alias ocat="/usr/lib/cargo/bin/coreutils/cat"

alias ff="fzf -m --preview 'bat --color=always {}' --preview-window=right:70%:wrap"
alias ffn="nvim \$(fzf -m --preview 'bat --color=always {}' --preview-window=right:70%:wrap)"

alias ghask="gh copilot explain"
alias ghsugg="gh copilot suggest"

alias OmniSharp="/home/caiogallo/.cache/omnisharp-vim/omnisharp-roslyn/run"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Start Docker daemon automatically when logging in if not running.
RUNNING=`ps aux | grep dockerd | grep -v grep`
if [ -z "$RUNNING" ]; then
    sudo dockerd > /dev/null 2>&1 &
    disown
fi

export PATH="/usr/bin/gotes:$PATH"
export PATH="$HOME/.atuin/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH="/home/caiogallo/.local/share/bob/nvim-bin:$PATH"
export DENO_INSTALL="/home/caiogallo/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export PATH=~/.composer/vendor/bin:$PATH
export PATH=~/.config/composer/vendor/bin/:$PATH
export PATH="/snap/bin:$PATH"
export JAVA_HOME=/usr/lib/jvm/default-java

export COLORTERM=truecolor

. "$HOME/.cargo/env"

#setxkbmap -layout us -variant intl
# setxkbmap -layout br -variant abnt2
# setxkbmap -option caps:escape

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Automatically start tmux if not already running
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  # tmux attach-session -t default || tmux new-session -s default
fi

# source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(zoxide init zsh)"

autoload -U +X bashcompinit && bashcompinit

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

export PATH="$PATH:/home/caiogallo/.local/bin"
export PATH=/usr/lib/cargo/bin/coreutils:$PATH

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
