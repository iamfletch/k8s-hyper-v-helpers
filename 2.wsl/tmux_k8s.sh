#!/usr/bin/env bash
SESSION="k8s"

if tmux has-session -t $SESSION 2>/dev/null; then
  echo "Session $SESSION already exists. Attaching..."
  exec tmux attach -t $SESSION
fi

tmux new-session -d -s $SESSION "ssh k8s-cp-0"
tmux split-window -h -t $SESSION "ssh k8s-cp-1"
tmux split-window -h -t $SESSION "ssh k8s-cp-2"
tmux split-window -v -t $SESSION:0.0 "ssh k8s-worker-0"
tmux split-window -v -t $SESSION:0.2 "ssh k8s-worker-1"
tmux split-window -v -t $SESSION:0.4 "ssh k8s-worker-2"

tmux select-layout -t $SESSION tiled
tmux set-window-option -t $SESSION synchronize-panes on

tmux attach -t $SESSION