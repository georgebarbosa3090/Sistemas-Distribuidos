#!/bin/bash

echo "Criando namespaces"

kubectl apply -f cluster/namespaces.yaml

echo "Configurando storage"

kubectl apply -f cluster/storage-class.yaml