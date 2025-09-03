# kubernetes setup in hyper-v

I do everything via WSL

## 0. Pre
WSL and Hyper-V should be installed first.
Download ubuntu 24.04 Server ISO

## 1. Hyper-V setup

Run `1.hyper-v/create.ps1` as administrator.

Manually go through the install process on all 6 servers, this could be automated or easier but it only takes 5 minutes.

I manually inputted the static IP's for these which are outside the dhcp range but still on my network.

For user creation i pick the same name as my WSL to make it easier

When given the option, install openssh and select keys to make the next steps easier.

## 2. WSL Setup

> [!NOTE]
> If you have different IP ranges, you will need to update all scripts.

Now all ther servers should be built and have their static IP set manually. 

As we are configuring all the hosts manually in ubuntu, I will make some useful tmux scripts

Here are some useful configurations to make the next steps a lot easier.

```bash
cd 2.wsl
./2.1.setup_ssh.sh
./2.2.setup_tmux.sh
```

## 3. Node setup
At the start all nodes are basically the same and will all need configuring

Following the [kubeadm guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) from now, with a bit of help from a friend [drewbernetes](https://www.youtube.com/@Drewbernetes).

Following the above guide, I have installed containerd, runc and cni all installed from latest releases on github. Then Installed kubeadm, kubelet and kubectl from apt.

ip_forward is enabled
Swap is off
echo 192.168.1.240 k8s-vip >> /etc/hosts

## 4. CP 0 setup

Created kube-vip manifest

Manually edit the kube-vip manifest to use super-admin config for init

init with Memory errors ignored because hyper-v dynamic memory is bad:
```
kubeadm init --control-plane-endpoint k8s-vip --apiserver-advertise-address 192.168.1.241 --ignore-preflight-errors Mem
# .... ignore all out really, just focus on this bit ...
You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join k8s-vip:6443 --token nga15w.qsyz6z6kk2u56dt4 \
        --discovery-token-ca-cert-hash sha256:c9f8d9679398d67f4fbb15d2788ccf12f9bebd22963a69c8564872fabbe69ece \
        --control-plane

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join k8s-vip:6443 --token nga15w.qsyz6z6kk2u56dt4 \
        --discovery-token-ca-cert-hash sha256:c9f8d9679398d67f4fbb15d2788ccf12f9bebd22963a69c8564872fabbe69ece
```

Manually edit kube-vip manifest back.

## 5. CP 1&2 setup
Copy kube-vip manifest

Run the join command from the init.

Kick your self for not using --upload-certs

