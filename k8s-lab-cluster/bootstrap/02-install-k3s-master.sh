#!/bin/bash

echo "Instalando K3S MASTER"

curl -sfL https://get.k3s.io | sh -

echo "Configurando kubectl"

mkdir -p $HOME/.kube
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $USER:$USER $HOME/.kube/config

echo "Cluster criado"

kubectl get nodes

echo "Token cluster"

sudo cat /var/lib/rancher/k3s/server/node-token