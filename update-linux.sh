#!/bin/bash

declare -a requirements=("sudo" "systemd" "wget")

echo "BDSM Server update script for Linux"

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

echo "Checking if BDSM is installed on your system..."
if [ ! -d "/usr/share/bdsm-server" && ! "/etc/systemd/system/bdsm-server.service" ]; then
  echo -e "[${RED}FATAL${RESET}] BDSM is not installed on your system ! Please install it using install-linux.sh first."
  exit 1
fi

echo "Disabling the bdsm-server service..."
systemctl disable bdsm-server --now

echo "Download bdsm-server-linux from GitHub..."
wget -O /tmp/bdsm-server-linux

echo "Move bdsm-server-linux file to /usr/share/bdsm-server..."
mv /tmp/bdsm-server-linux /usr/share/bdsm-server/bdsm-server-linux

echo "Activate the bdsm-server service..."
systemctl enable bdsm-server --now

echo "BDSM Server has been updated !"