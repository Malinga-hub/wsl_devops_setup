#!/bin/bash
echo "installing jenkins..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
          https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
          https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
            /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

if ! command docker --version &> /dev/null
then
sudo usermod -aG docker jenkins
systemctl restart docker
fi

if ! command microk8s status --version &> /dev/null
then
chown jenkins ~/.kube #change ownership to jenkins user for access during CI/CD to microk8s
systemctl restart jenkins
sudo usermod -aG m microk8s jenkins
fi



#sudo usermod -aG root jenkins
#newgrp root
