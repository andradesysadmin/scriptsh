#!/bin/bash

# Script de instalação do kind para todas as distribuições linux

# Verifica se o script foi executado com os devidos privilégios
if [ "$(id -u)" -ne 0 ]; then
    echo "O script deve ser executado com privilégios de super usuário!"
    exit 1
fi

sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
if command -v kubectl &> /dev/null; then
  echo "Kubectl instalado com sucesso!"
else
  echo "Erro, kubectl não instalado!"
fi
