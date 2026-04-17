#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Autostart or re-attach tmux with dynamic session name and interactive shell detection
SESSION_NAME="$(whoami)@$(hostname)"

if [[ $- == *i* ]] && command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach-session -t "$SESSION_NAME" || tmux new-session -s "$SESSION_NAME"
fi