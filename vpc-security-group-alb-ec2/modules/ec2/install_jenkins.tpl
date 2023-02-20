#!/bin/bash
sudo apt install openjdk-11-jdk-headless -y
sudo apt update
sudo apt upgrade -y
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo sh -c 'echo deb http://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt install jenkins
sudo systemctl status jenkins
sudo systemctl start jenkins
sudo systemctl enable --now jenkins
sudo ufw allow 8080/tcp
sudo ufw reload