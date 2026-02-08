# STOW-OVERRIDE-BLOCK
# run fastfetch at startup
fastfetch

## alias(es)
alias cat='bat'
alias code='flatpak run com.vscodium.codium'
alias diff='batdiff'
alias grep='batgrep'
alias lj='ls --color=auto --group-directories-first -ahl'
alias ls='ls --color=auto --group-directories-first'
alias man='batman'
alias pkgdep="pacman -Qq | fzf --preview 'pactree -lur {} | sort' --layout reverse --bind 'enter:execute(pactree -lu {} | sort | less)'"
alias protontricks='flatpak run com.github.Matoking.protontricks'
alias protontricks-launch='flatpak run --command=protontricks-launch com.github.Matoking.protontricks'
alias reminder='cat .tmp/scratch/reminder.txt'
alias tree='tree -C --dirsfirst'
alias whatsmyip='dig +short myip.opendns.com @resolver1.opendns.com'

# function path for zsh-completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# environmnet variables
export BAT_THEME=OneHalfDark
export PATH=$HOME/bin:$PATH

# double whitespace included for better aesthetics in final .zshrc

