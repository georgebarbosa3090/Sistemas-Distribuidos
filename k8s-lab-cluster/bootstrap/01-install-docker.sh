#!/bin/bash

echo "Atualizando sistema"
sudo apt update -y

echo "Instalando dependências"
sudo apt install -y \
apt-transport-https \
ca-certificates \
curl \
software-properties-common

echo "Adicionando chave docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "Adicionando repositorio"
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

sudo apt update -y

echo "Instalando docker"
sudo apt install -y docker-ce docker-ce-cli containerd.io

sudo systemctl enable docker
sudo systemctl start docker

docker --version