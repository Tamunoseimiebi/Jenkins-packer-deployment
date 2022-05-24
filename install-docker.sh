#!/bin/bash

echo "Refreshing Apt Repository"
sudo apt-get update -y

echo "Installing Docker Engine"

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Adding user to docker group"

sudo usermod -aG docker e4edevops

echo "Installing Docker Compose"

sudo apt-get install docker-compose-plugin

echo "Checking Docker version"

docker -v

echo "Checking Docker Compose version"

docker compose version





