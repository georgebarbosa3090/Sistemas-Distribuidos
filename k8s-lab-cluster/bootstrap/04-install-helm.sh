#!/bin/bash
set -e

echo "[INFO] Instalando Helm..."

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm version

echo "[OK] Helm instalado"
