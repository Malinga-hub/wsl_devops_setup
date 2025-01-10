#!/bin/bash
echo "installing java jdk21.."
sudo apt update
sudo apt install fontconfig openjdk-21-jdk
java -version

echo "remember to set JAVA_HOME is ~/.bashrc file"
#export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
#export PATH=$JAVA_HOME/bin:$PATH
