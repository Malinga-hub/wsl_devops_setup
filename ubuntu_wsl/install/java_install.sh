#!/bin/bash
echo "installing java jdk21.."
sudo apt-get update -y
sudo apt install openjdk-21-jdk -y
java -version

echo "setting java home.."
echo "export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64" >> ~/.bashrc
# shellcheck disable=SC1090
source ~/.bashrc

echo "reboot required"
