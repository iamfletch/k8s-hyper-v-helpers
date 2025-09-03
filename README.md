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

