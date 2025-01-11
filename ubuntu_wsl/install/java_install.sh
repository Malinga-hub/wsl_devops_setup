#!/bin/bash
echo "installing java jdk21.."
sudo apt update
sudo apt install fontconfig openjdk-21-jdk
java -version

echo "setting java home.."
echo "export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64" >> ~/.bashrc
#echo "export PATH=$JAVA_HOME/bin:$PATH" >> ~/.bashrc
# shellcheck disable=SC1090
source ~/.bashrc

echo "please restart your server for changes to take effect"
