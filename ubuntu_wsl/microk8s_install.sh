#!/bin/bash
echo "installing microk8s..."
sudo apt update && sudo apt upgrade -y
sudo snap install microk8s --classic

echo "adding microk8s user and group..."
sudo usermod -aG microk8s $USER
newgrp microk8s

#optional
#set alias=microk8s kubectl -> ~/.bashrc -> source ~/.bashrc -> to save settings