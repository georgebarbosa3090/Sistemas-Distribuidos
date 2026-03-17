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

## 🐄 Instalação do Rancher no Cluster k3s

O Rancher é uma plataforma de gerenciamento de clusters Kubernetes que permite:

- Interface gráfica para administração
- Gestão de múltiplos clusters
- Controle de usuários e permissões
- Deploy simplificado de aplicações

---

## ⚙️ 1. Pré-requisitos

Antes de instalar o Rancher:

- Cluster k3s funcional
- kubectl configurado
- Helm instalado

Verifique:

```bash
kubectl get nodes
helm version
```
---

## 🐄 Instalação do Rancher no Cluster k3s

O Rancher é uma plataforma de gerenciamento de clusters Kubernetes que permite:

- Interface gráfica para administração
- Gestão de múltiplos clusters
- Controle de usuários e permissões
- Deploy simplificado de aplicações

---

### ⚙️ 1. Pré-requisitos

Antes de instalar o Rancher:

- Cluster k3s funcional
- kubectl configurado
- Helm instalado

Verifique:

```bash
kubectl get nodes
helm version
````

---

### ⚙️ 2. Instalação do Cert-Manager

O Rancher requer certificados TLS.

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml

kubectl create namespace cert-manager

kubectl wait --for=condition=available deployment/cert-manager -n cert-manager --timeout=120s
```

---

### ⚙️ 3. Adicionar repositório do Rancher

```bash
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

helm repo update
```

---

### ⚙️ 4. Criar namespace

```bash
kubectl create namespace cattle-system
```

---

### ⚙️ 5. Instalar Rancher

```bash
helm upgrade --install rancher rancher-stable/rancher \
--namespace cattle-system \
--set hostname=rancher.localhost \
--set replicas=1
```

---

### ⚙️ 6. Verificar instalação

```bash
kubectl -n cattle-system rollout status deploy/rancher
```

---

### ⚙️ 7. Acessar Rancher

Obter IP:

```bash
kubectl get svc -n cattle-system
```

Acesse:

```
http://<NODE-IP>
```

---

### ⚙️ 8. Obter senha inicial

```bash
kubectl get secret --namespace cattle-system bootstrap-secret \
-o go-template='{{.data.bootstrapPassword|base64decode}}'
```

---

### 🛠️ 9. Versão Manual (Didática)

## Criar namespace

```bash
kubectl create namespace cattle-system
```

### Instalar via Helm

```bash
helm install rancher rancher-stable/rancher \
--namespace cattle-system \
--set hostname=rancher.localhost
```

---

## 📌 10. Finalidade

O Rancher permite transformar este cluster em:

* Plataforma institucional
* Ambiente de ensino DevOps
* Laboratório de computação distribuída

````

---

# 🔧 SCRIPT PROFISSIONAL DO RANCHER

## 📄 `infrastructure/rancher/install-rancher.sh`

```bash
#!/bin/bash
set -e

echo "[INFO] Instalando Cert-Manager..."

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml

kubectl create namespace cert-manager || true

echo "[INFO] Aguardando Cert-Manager..."

kubectl wait --for=condition=available deployment/cert-manager \
-n cert-manager --timeout=180s

echo "[INFO] Adicionando repositório Rancher..."

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable || true
helm repo update

echo "[INFO] Criando namespace cattle-system..."

kubectl create namespace cattle-system || true

echo "[INFO] Instalando Rancher..."

helm upgrade --install rancher rancher-stable/rancher \
--namespace cattle-system \
--set hostname=rancher.localhost \
--set replicas=1

echo "[INFO] Aguardando Rancher..."

kubectl -n cattle-system rollout status deploy/rancher

echo "[OK] Rancher instalado com sucesso"
````

---

## 🔧 ATUALIZAÇÃO DO SCRIPT DE INFRA

### 📄 `scripts/deploy-infra.sh` (ATUALIZADO)

```bash
#!/bin/bash
set -e

echo "[INFO] Instalando Rancher..."
bash infrastructure/rancher/install-rancher.sh

echo "[INFO] Instalando monitoramento..."
kubectl apply -f infrastructure/monitoring/

echo "[OK] Infraestrutura completa"
```

---

# 🧠 OBSERVAÇÕES IMPORTANTES

## ⚠️ Sobre acesso local

`rancher.localhost` pode não funcionar direto.

👉 Alternativas:

### 1. Editar hosts

```bash
sudo nano /etc/hosts
```

Adicionar:

```
SEU_IP rancher.localhost
```

---

### 2. Usar NodePort temporário

```bash
kubectl expose deployment rancher \
-n cattle-system \
--type=NodePort \
--port=80
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

