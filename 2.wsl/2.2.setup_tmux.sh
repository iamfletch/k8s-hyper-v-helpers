#!/usr/bin/env bash
BIN="$HOME/.local/bin"

# make sure ~/.local/bin exists and setup
mkdir -p $BIN

if ! grep -q $BIN <<<$PATH ; then
    sed -ibak '/#K8S-START/,/#K8S-END/d' $HOME/.bashrc
    cat >>$HOME/.bashrc <<EOL
#K8S-START
export PATH=$BIN:\$PATH
#K8S-END
EOL
    echo "Reload your .bashrc (source ~/.bashrc)"
fi

# install our stuff
source=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd )
install -m 750 $source/tmux_k8s.sh $BIN/tmux_k8s