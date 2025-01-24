#!/bin/bash

# Get the current workspace number
current_workspace=$(i3-msg -t get_workspaces | jq '.[] | select(.focused == 'true') | .num')


# Get the number of workspaces
num_workspaces=$(i3-msg -t get_workspaces | jq '.[] | .num' | wc -l)

# Move to the next workspace
if [ "$1" = "next" ]; then
    if [ $current_workspace -eq $num_workspaces ]; then
        i3-msg workspace $(($num_workspaces + 1))
    else
        i3-msg workspace $(($current_workspace + 1))
    fi
fi

# Move to the previous workspace
if [ "$1" = "prev" ]; then
    if [ $current_workspace -eq 1 ]; then
        i3-msg workspace 1
    else
        i3-msg workspace $(($current_workspace - 1))
    fi
fi

