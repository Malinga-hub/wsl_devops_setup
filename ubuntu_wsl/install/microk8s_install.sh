#!/bin/bash
echo "ensure docker installed before proceeding..."
if ! command docker --version &> /dev/null
then echo "docker not installed. exiting.." exit 1
fi

echo "installing microk8s..."
sudo apt update && sudo apt upgrade -y
sudo snap install microk8s --classic

echo "adding alias kubectl=microk8s kubectl  to ~/.basrhrc ..."
echo "alias kubectl='microk8s kubectl'" >> ~/.bashrc
# shellcheck disable=SC1090
source ~/.bashrc

echo "setting docker private registry..."
echo -e '{\n "insecure-registries": ["localhost:32000"] \n}' > /etc/docker/daemon.json

echo "restarting docker..."
service docker restart

echo "adding microk8s user and group..."
sudo usermod -aG microk8s "$USER"
newgrp microk8s

echo "installation complete"