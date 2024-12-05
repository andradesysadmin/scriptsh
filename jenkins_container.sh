#!/bin/bash

CONTAINER_NAME="jenkins"
IMAGE_NAME="jenkins/jenkins:lts"
HOST_PORT=8080
CONTAINER_PORT=8080
JENKINS_HOME_VOLUME="jenkins_home"

# Verificar se o Docker está instalado e em execução
if ! command -v docker &> /dev/null; then
  echo "Docker não está instalado. Instale o Docker e tente novamente."
  exit 1
fi

if ! sudo systemctl is-active --quiet docker; then
  echo "O serviço Docker não está em execução. Iniciando o Docker..."
  sudo systemctl start docker
  if [ $? -ne 0 ]; then
    echo "Falha ao iniciar o Docker. Verifique o serviço Docker."
    exit 1
  fi
fi

# Parar e remover o container existente, se ele já estiver em execução
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^$CONTAINER_NAME\$"; then
  echo "Parando e removendo o container existente: $CONTAINER_NAME"
  sudo docker stop "$CONTAINER_NAME" && sudo docker rm "$CONTAINER_NAME"
  if [ $? -ne 0 ]; then
    echo "Falha ao parar ou remover o container existente."
    exit 1
  fi
fi

# Executar o container Jenkins com a configuração de volumes persistentes
echo "Executando o container Jenkins..."
sudo docker run --name "$CONTAINER_NAME" \
  -p "$HOST_PORT":"$CONTAINER_PORT" \
  -v "$JENKINS_HOME_VOLUME":/var/jenkins_home \
  --restart always \
  -d "$IMAGE_NAME"

# Verificar se o container iniciou com sucesso
if [ $? -eq 0 ]; then
  echo "Container Jenkins iniciado com sucesso. Acesso disponível na porta $HOST_PORT."
else
  echo "Falha ao iniciar o container Jenkins."
  exit 1
fi
