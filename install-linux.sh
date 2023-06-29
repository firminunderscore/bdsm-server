#!/usr/bin/env sh

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\e[0;35m'
RESET='\e[0m'

declare -a requirements=("git" "node" "npm")

isInstalled() {
  $1 --version &> /dev/null
  if (($? != 0 ))
  then 
    echo -e"[${RED}FATAL${RESET}] $1 is not installed ! Please install it using your package manager first."
    exit 1
  fi
}

isRoot() {
  uid=$(id -u)
  if (($uid == 0))
  then
    echo -e "[${RED}FATAL${RESET}] Running as root is not supported ! Please run as regular user, you will be prompted for root rights when needed"
    exit 2
  fi
}

isRoot
for i in ${requirements[@]};do
  isInstalled $i
done

echo -e "[ ${GREEN}HINT${RESET} ] Installing in $(pwd)"
git clone https://github.com/firminsurgithub/bdsm-server.git
cd bdsm-server
read -p $'[\e[35mPROMPT\e[0m] Please enter a name for your server: ' name
read -p $'[\e[35mPROMPT\e[0m] Please enter the port the server will run on: ' port
read -sp $'[\e[35mPROMPT\e[0m] Please enter a password to connect to the server: ' password
echo ""

echo """
SERVER_NAME="${name}"
PORT=${port}
PASSWORD="${password}"
""" > .env

echo -e "[${GREEN}HINT${RESET}] Downloading packages"
npm install
echo -e "[${CYAN}SERVICE${RESET}] Writing systemD service"
echo """
[Unit]
Description=BDSM Server unit service
After=network.target
Type=simple
Restart=always
RestartSec=1
WorkingDirectory=$(pwd)/bdsm-server
ExecStart=$(whereis npm | cut -d' ' -f2) start

[Install]
WantedBy=multi-user.target
""" | sudo tee /etc/systemd/system/bdsm.service &> /dev/null
echo -e "[${CYAN}SERVICE${RESET}] Enabling service"

sudo systemctl enable --now bdsm
echo -e "[${GREEN}HINT${RESET}] Installation done"