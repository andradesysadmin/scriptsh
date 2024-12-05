#!/bin/bash


if command -v kind &> /dev/null; then
  echo "Kind já está instalado!"
  exit 1
fi

# Verifica se o script foi executado com os devidos privilégios
if [ "$(id -u)" -ne 0 ]; then
    echo "O script deve ser executado com privilégios de super usuário!"
    exit 1
fi

[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.25.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

if command -v kind &> /dev/null; then
  echo "Kind instalado com sucesso!"
else
  echo "Erro, kind não instalado!"
fi
