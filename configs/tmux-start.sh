#!/bin/bash

SESSION="ruby-dev"

# Check if session already exists
if ! tmux has-session -t $SESSION 2>/dev/null
then
	# Create a new session, detached (-d)
	tmux new-session -d -s $SESSION -n "editor"

	# Split horizontally
	tmux split-window -h -p 30 -t $SESSION

	tmux set-option -t $SESSION:1.2 remain-on-exit on
	# Select the main editor pane
	tmux select-pane -t 1
fi

# Attach to the session
clear
tmux attach-session -t $SESSION

