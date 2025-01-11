#!/bin/bash
echo "installed docker version.."
docker --version

echo "removing docker.."
sudo service docker stop
sudo apt-get remove --purge docker-ce docker-ce-cli containerd.io
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker

echo "cleaning.."
sudo apt autoremove && sudo apt clean -y

