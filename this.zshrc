
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.L
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $ZSH/oh-my-zsh.sh
plugins=(git zsh-bat zsh-autosuggestions)
export BAT_THEME="Catppuccin Mocha"

export PIP_REQUIRE_VIRTUALENV=true
syspip() {
    PIP_REQUIRE_VIRTUALENV="" python3 -m pip "$@" 
}

export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Network fixes, probably not needed
#export CERT_PATH=$(python3.12 -m certifi)
#export SSL_CERT_FILE=${CERT_PATH}
#export REQUESTS_CA_BUNDLE=${CERT_PATH}

# Aliases

alias ll='ls -lhG'
alias pcr='pre-commit run --all-files'
alias python=python3
alias pip=pip3
alias got=git
# These are nice if installed
alias cat=bat
alias ls=eza
alias getsha='git rev-parse --short HEAD'

# Keybinds

# C-y for autocomplete
bindkey '^Y' autosuggest-accept

# fzf-into-vim
vf() {
  vim $(fzf -m)
}
