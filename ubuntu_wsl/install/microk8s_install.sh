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
#optional for microk8s kubernetes default dashboard - can be commented out if not necessary
echo "alias k8s_token='microk8s kubectl describe secret -n kube-system microk8s-dashboard-token'" >> ~/.bashrc
# shellcheck disable=SC1090
source ~/.bashrc

echo "setting docker private registry..."
echo -e '{\n "insecure-registries": ["localhost:32000"] \n}' > /etc/docker/daemon.json

echo "restarting docker..."
systemctl restart docker

echo "adding docker private docker registry service to be used by microk8s"

sudo tee /etc/systemd/system/docker-registry.service > /dev/null << EOF
[Unit]
Description=Docker Registry Service
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run -p 32000:5000 --name registry -v /data/backups/docker-registry:/var/lib/registry registry:2
ExecStop=/usr/bin/docker stop registry
ExecStopPost=/usr/bin/docker rm registry

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading daemon services..."
sudo systemctl daemon-reload
echo "Starting docker-registry service"
systemctl start docker-registry.service
echo "Enabling docker-registry service..." #always starts automatically when server re-booted
sudo systemctl enable docker-registry.service
echo "testing docker registry"
curl http://localhost:32000/v2/_catalog

echo "adding microk8s user and group..."
sudo usermod -aG microk8s "$USER"
newgrp microk8s

echo "installation complete"