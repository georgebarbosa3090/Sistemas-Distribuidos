#!/bin/bash
set -e

MASTER_IP=$1
TOKEN=$2

if [ -z "$MASTER_IP" ] || [ -z "$TOKEN" ]; then
  echo "Uso: ./install-k3s-worker.sh <MASTER_IP> <TOKEN>"
  exit 1
fi

echo "[INFO] Conectando worker ao cluster..."

curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_IP:6443 \
K3S_TOKEN=$TOKEN sh -

echo "[OK] Worker conectado"
