#!/bin/bash
echo "stopping microk8s.."
sudo microk8s stop
sudo microk8s disable

echo "removing microk8s"
sudo snap remove microk8s
sudo rm -rf /var/snap/microk8s/
sudo rm -rf /var/snap/microk8s-common/

echo "cleaning.."
sudo apt autoremove && sudo apt clean -y