#!/bin/bash
echo "current java version.."
java --version

echo "removing java"
sudo apt-get remove --purge openjdk-21-jdk

echo "cleaning.."
sudo apt autoremove && sudo apt clean -y