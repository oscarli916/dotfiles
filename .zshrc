# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export PATH="$HOME/.local/bin:$PATH"
export PATH=/$HOME/.opencode/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=( 
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch

# zsh-autosuggestions configuration
ZSH_AUTOSUGGEST_STRATEGY=(completion history)

bindkey '^ ' autosuggest-accept
bindkey -s '^f' '$HOME/personal/dotfiles/tmux-sessionizer^M'

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
if ! command -v podman >/dev/null 2>&1; then
    alias podman='podman.exe'
fi
alias docker='podman'
if ! command -v kubectl >/dev/null 2>&1; then
    alias kubectl='kubectl.exe'
fi
alias k='kubectl'

# start Starship
eval "$(starship init zsh)"

# start fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
