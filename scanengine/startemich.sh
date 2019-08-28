#!/bin/sh
/usr/bin/tmux new-session -d -n "Monitor" -s monitor '/home/bigfreak/mvscan/mvscan.sh'
#/usr/bin/tmux send -t monitor '/home/bigfreak/mvscan/mvscan.sh' ENTER
/usr/bin/tmux selectp -t monitor
/usr/bin/tmux split-window -v -p 50 '/home/bigfreak/mvdaten/mvdaten.sh'
/usr/bin/tmux new-window -t monitor -n "lsscansmb" 'watch -n 10 ls -R /home/bigfreak/mvscan/dest'
/usr/bin/tmux new-window -t monitor -n "lsdatenssmb" 'watch -n 10 ls -R /home/bigfreak/mvdaten/dest'
/usr/bin/tmux select-window -t "Monitor"
/usr/bin/tmux -2 attach-session -t monitor 
