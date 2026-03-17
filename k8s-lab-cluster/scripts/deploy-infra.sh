#!/bin/bash
set -e

echo "[INFO] Instalando monitoramento..."

kubectl apply -f infrastructure/monitoring/

echo "[OK] Infraestrutura implantada"
