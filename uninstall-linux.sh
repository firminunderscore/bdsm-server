#!/bin/bash

echo "Disabling the bdsm-server service..."
systemctl disable bdsm-server --now

echo "Removing the bdsm-server service..."
rm /etc/systemd/system/bdsm-server.service

echo "Removing the /usr/share/bdsm-server directory..."
rm -rf /usr/share/bdsm-server

echo "Uninstall complete !"