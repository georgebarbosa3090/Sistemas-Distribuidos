#!/bin/bash
set -e

echo "[INFO] Deploy MongoDB..."

kubectl apply -f apps/mongodb/

echo "[OK] Aplicações implantadas"
