#!/usr/bin/env bash

# First connect to all hosts, get hostsnames and trust their hostkeys
sed -ibak '/#K8S-START/,/#K8S-END/d' $HOME/.ssh/config
(
echo "#K8S-START"
for ip in "192.168.1."{241..246}; do
    hostname=$(ssh -o StrictHostKeyChecking=accept-new $ip hostname)
    echo "Found $hostname: $ip" >&2
    cat <<EOL
Host $hostname
  HostName $ip

EOL
done
echo "#K8S-END"
) >> $HOME/.ssh/config
