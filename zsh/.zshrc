# Run fastfetch at startup
fastfetch

# Aliases
alias ll='ls --color=auto --group-directories-first -lGha'
alias lo='ls --color=auto --group-directories-first -oah'
alias code='codium'
alias cat='bat'
alias protontricks='flatpak run com.github.Matoking.protontricks'
alias protontricks-launch='flatpak run --command=protontricks-launch com.github.Matoking.protontricks'

# function path for zsh-completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# double whitespace included for better aesthetics in final .zshrc

