# shellcheck disable=SC2148
# ~/.bashrc

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

## alias(es)
alias cat='bat'
alias code='codium'
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

## original prompt
# PS1='[\u@\h \W]\$ '

## custom prompt
# define prompt colors
COL_USER='\[\e[30m\]' # the color of 'username'
COL_HOST='\[\e[30m\]' # the color of 'host.domain'
COL_CURSOR='\[\e[30m\]' # the color of the trailing cursor
COL_CURRENT_PATH='\[\e[37m\]' # the color of the current directory full path
COL_GIT_STATUS_CLEAN='\[\e[93m\]' # color of fresh git branch name, with NO changes
COL_GIT_STATUS_CHANGES='\[\e[92m\]' # color of git branch, affter its diverged from remote

# text styles
BOLD='\[\e[1m\]' # bold
RESET='\[\e[0m\]' # reset colors

# config
SHOW_GIT=$(command -v git)

# if this is a valid git repo, echo the current branch name
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# color the git branch (depending on changes)
parse_git_changes() {
    if [[ $(git status --porcelain) ]]; then
    echo "${COL_GIT_STATUS_CLEAN}"
    else
    echo "${COL_GIT_STATUS_CHANGES}"
    fi
}

# build the final PS1 string
set_bash_prompt() {
    PS1="${RESET}"
    PS1+="┌${BOLD}${COL_USER} \u@${COL_HOST}\h ${RESET}${COL_CURRENT_PATH}\w "

    if [ "$SHOW_GIT" = true ] && [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = true ] ; then
    PS1+="$(parse_git_changes)"
    PS1+="$(parse_git_branch)"
    fi

    PS1+="\n└${RESET} ${COL_CURSOR}\$ "
}

# check if running in a terminal emulator or in the virtual console
if [ "$TERM" = linux ]; then
    PROMPT_COMMAND=set_bash_prompt
else
    eval "$(oh-my-posh init bash --config "$HOME"/.cache/oh-my-posh/themes/stelbent.minimal.omp.json)"
fi

# environment variables
export BAT_THEME=OneHalfDark
export PATH=$HOME/bin:$PATH