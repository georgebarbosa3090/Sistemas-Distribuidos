# 🚀 📂 Projeto Sistema Distribuidos - Guia de Instalação do Cluster Kubernetes (k3s)

Este documento descreve o processo completo de instalação e execução de um cluster baseado em Kubernetes utilizando k3s, incluindo automação e execução manual para fins didáticos.

---

## ⚙️ 1. Objetivo

Implantar um ambiente de orquestração de containers com:

- Kubernetes (k3s)
- Deploy automatizado
- Monitoramento básico
- Persistência de dados

---

## ⚙️ 2. Pré-requisitos

- Ubuntu 20.04+
- Usuário com sudo
- Acesso à internet
- Mínimo:
  - 2 CPUs
  - 4GB RAM

---

## ⚙️ 3. Instalação Automatizada (Scripts)

### 🔹 3.1 Atualizar sistema

```bash
sudo apt update -y && sudo apt upgrade -y
```

## 🔹 3.2 Instalar dependências

```bash
sudo apt install -y curl git
```

---

## 🔹 3.3 Executar script Docker

```bash
chmod +x bootstrap/01-install-docker.sh
./bootstrap/01-install-docker.sh
```

---

## 🔹 3.4 Instalar k3s (Master)

```bash
chmod +x bootstrap/02-install-k3s-master.sh
./bootstrap/02-install-k3s-master.sh
```

---

## 🔹 3.5 Instalar Helm

```bash
chmod +x bootstrap/04-install-helm.sh
./bootstrap/04-install-helm.sh
```

---

## 🔹 3.6 Deploy do cluster

```bash
chmod +x scripts/deploy-cluster.sh
./scripts/deploy-cluster.sh
```

---

## 🔹 3.7 Deploy da infraestrutura

```bash
chmod +x scripts/deploy-infra.sh
./scripts/deploy-infra.sh
```

---

## 🔹 3.8 Deploy das aplicações

```bash
chmod +x scripts/deploy-apps.sh
./scripts/deploy-apps.sh
```

---

## 🔹 3.9 Validação

```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
```

---

## 🛠️ 4. Versão Manual (Didática)

Este modo permite compreender o funcionamento interno do Kubernetes sem automação.

---

### 🔹 4.1 Instalar k3s manualmente

```bash
curl -sfL https://get.k3s.io | sh -
```

---

### 🔹 4.2 Configurar kubectl

```bash
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
```

---

### 🔹 4.3 Criar namespace

```bash
kubectl create namespace applications
```

---

### 🔹 4.4 Criar deployment

```bash
kubectl create deployment nginx --image=nginx -n applications
```

---

### 🔹 4.5 Escalar aplicação

```bash
kubectl scale deployment nginx --replicas=3 -n applications
```

---

### 🔹 4.6 Expor serviço

```bash
kubectl expose deployment nginx \
--port=80 \
--type=NodePort \
-n applications
```

---

### 🔹 4.7 Verificar recursos

```bash
kubectl get all -n applications
```

---
# 🔧 SCRIPTS

### 📄 `bootstrap/01-install-docker.sh`

```bash
#!/bin/bash
set -e

echo "[INFO] Instalando Docker..."

sudo apt update -y

sudo apt install -y \
apt-transport-https \
ca-certificates \
curl \
software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io

sudo systemctl enable docker
sudo systemctl start docker

echo "[OK] Docker instalado"
````

---

### 📄 `bootstrap/02-install-k3s-master.sh`

```bash
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
```

---

### 📄 `bootstrap/03-install-k3s-worker.sh`

```bash
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
```

---

### 📄 `bootstrap/04-install-helm.sh`

```bash
#!/bin/bash
set -e

echo "[INFO] Instalando Helm..."

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm version

echo "[OK] Helm instalado"
```

---

### 📄 `scripts/deploy-cluster.sh`

```bash
#!/bin/bash
set -e

echo "[INFO] Criando namespaces..."

kubectl apply -f cluster/namespaces.yaml

echo "[INFO] Configurando storage..."

kubectl apply -f cluster/storage-class.yaml

echo "[OK] Cluster base configurado"
```

---

### 📄 `scripts/deploy-infra.sh`

```bash
#!/bin/bash
set -e

echo "[INFO] Instalando monitoramento..."

kubectl apply -f infrastructure/monitoring/

echo "[OK] Infraestrutura implantada"
```

---

### 📄 `scripts/deploy-apps.sh`

```bash
#!/bin/bash
set -e

echo "[INFO] Deploy MongoDB..."

kubectl apply -f apps/mongodb/

echo "[OK] Aplicações implantadas"
```

---

## 📄 Licença

Este projeto está sob a licença MIT.
Veja o arquivo `LICENSE` para mais detalhes.

---

# ✨ Autor

**Seu Nome**
GitHub: [https://github.com/seuusuario](https://github.com/georgebarbosa3090)
LinkedIn: [https://linkedin.com/in/seuusuario](https://www.linkedin.com/in/george-barbosa-82a2aa109)


Qual estilo você prefere?

