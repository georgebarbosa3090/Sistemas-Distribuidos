#!/bin/bash
set -e

echo "[INFO] Criando namespaces..."

kubectl apply -f cluster/namespaces.yaml

echo "[INFO] Configurando storage..."

kubectl apply -f cluster/storage-class.yaml

echo "[OK] Cluster base configurado"
