#!/bin/bash

declare -a requirements=("sudo" "systemd")

echo "BDSM Server remove script for Linux"

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
  echo -e "[${RED}FATAL${RESET}] BDSM is not installed on your system ! Can't uninstall it."
  exit 1
fi

echo "Disabling the bdsm-server service..."
systemctl disable bdsm-server --now

echo "Removing the bdsm-server service..."
rm /etc/systemd/system/bdsm-server.service

echo "Removing the /usr/share/bdsm-server directory..."
rm -rf /usr/share/bdsm-server

echo "Uninstall complete !"