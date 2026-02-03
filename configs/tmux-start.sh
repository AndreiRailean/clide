#!/bin/bash

SESSION="ruby-dev"

# Check if session already exists
tmux has-session -t $SESSION 2>/dev/null

if [ $? != 0 ]; then
  # Create a new session, detached (-d)
  tmux new-session -d -s $SESSION -n "editor"
  
  # Split horizontally
  tmux split-window -h -p 35 -t $SESSION
  
  # Select the main editor pane
  tmux select-pane -t 1
fi

# Attach to the session
clear
tmux attach-session -t $SESSION

