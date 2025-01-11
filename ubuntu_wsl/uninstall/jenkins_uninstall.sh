#!/bin/bash
echo "installed jenkins version..."
jenkins --version

echo "removing jenkins.."
sudo service jenkins stop
sudo jenkins disable
sudo apt-get remove --purge jenkins
sudo rm -rf /var/lib/jenkins/
sudo rm -rf /var/cache/jenkins

echo "cleaning.."
sudo apt autoremove && sudo apt clean -y
