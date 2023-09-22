#!/usr/bin/env bash

declare -a requirements=("sudo" "systemd" "wget")

echo "BDSM Server installation script for Linux"

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

isInstalled() {
  $1 --version &> /dev/null
  if (($? != 0 ))
  then 
    echo -e"[${RED}FATAL${RESET}] $1 is not installed ! Please install it using your package manager first."
    exit 1
  fi
}

for i in ${requirements[@]};do
  isInstalled $i
done

echo "Download bdsm-server-linux from GitHub..."
wget -O /tmp/bdsm-server-linux https://github.com/firminsurgithub/bdsm-server/releases/latest/download/bdsm-server-linux

echo "Create /usr/share/bdsm-server directory..."
mkdir -p /usr/share/bdsm-server

echo "Move bdsm-server-linux file to /usr/share/bdsm-server..."
mv /tmp/bdsm-server-linux /usr/share/bdsm-server/bdsm-server-linux

echo "Please enter the following values :"
read -u 1 -p $'[\e[35mPROMPT\e[0m] Please enter a name for your server: ' SERVER_NAME
read -u 1 -p $'[\e[35mPROMPT\e[0m] Please enter the port the server will run on: ' PORT
read -u 1 -sp $'[\e[35mPROMPT\e[0m] Please enter a password to connect to the server: ' PASSWORD

echo "SERVER_NAME=$SERVER_NAME" > /usr/share/bdsm-server/.env
echo "PORT=$PORT" >> /usr/share/bdsm-server/.env
echo "PASSWORD=$PASSWORD" >> /usr/share/bdsm-server/.env

echo "Creation of the systemd bdsm-server service..."
echo "[Unit]
Description=BDSM Server unit service
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/usr/share/bdsm-server/bdsm-server-linux
WorkingDirectory=/usr/share/bdsm-server

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/bdsm-server.service

chmod +x /usr/share/bdsm-server/bdsm-server-linux

echo "Activate the bdsm-server service..."
systemctl enable bdsm-server --now

echo "The script has been successfully executed!"
