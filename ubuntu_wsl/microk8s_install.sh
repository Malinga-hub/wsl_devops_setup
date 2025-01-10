#!/bin/bash
echo "installing microk8s..."
sudo apt update && sudo apt upgrade -y
sudo snap install microk8s --classic

echo "adding microk8s user and group..."
sudo usermod -aG microk8s $USER
sudo chown -R $USER ~/.kube
newgrp microk8s

echo "enabling microk8s as service..."
sudo systemctl enable snap.microk8s.daemon.service
sudo systemctl start snap.microk8s.daemon.service
sudo systemctl status snap.microk8s.daemon.service


#optional
#set alias=microk8s kubectl -> ~/.bashrc -> source ~/.bashrc -> to save settings