# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=( 
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# fastfetch. Will be disabled if above colorscript was chosen to install
fastfetch

# zsh-autosuggestions configuration
ZSH_AUTOSUGGEST_STRATEGY=(completion history)

bindkey '^ ' autosuggest-accept
bindkey -s '^f' '/home/oscar/personal/tmux-sessionizer^M'

# alias
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias c='clear'
alias v='nvim'
alias nv='nvim'
alias n='nvim'

# start Starship
eval "$(starship init zsh)"

# start fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# opencode
export PATH=/home/oscar/.opencode/bin:$PATH
