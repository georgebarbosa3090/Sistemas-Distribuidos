#!/bin/bash
set -e

echo "[INFO] Instalando K3s (MASTER)..."

curl -sfL https://get.k3s.io | sh -

mkdir -p $HOME/.kube
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $USER:$USER $HOME/.kube/config

echo "[INFO] Verificando cluster..."
kubectl get nodes

echo "[INFO] Token do cluster:"
sudo cat /var/lib/rancher/k3s/server/node-token
