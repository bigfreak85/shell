#!/bin/sh 
tmux new-session -d -s mukke 'zsh'
tmux selectp -t mukke
tmux split-window -v -p 50 'alsamixer -c 0'
tmux split-window -h -p 50 'cmus'
tmux -2 attach-session -t mukke 
