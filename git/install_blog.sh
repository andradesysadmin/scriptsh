#!/bin/bash

# Script de instalação do meu blog contruido em e docker laravel

if [ "$(id -u)" -ne 0 ]; then
    echo "O script deve ser executado com privilégios de super usuário!"
    exit 1
fi

APP_NAME="blog"

if command -v git >/dev/null 2>&1; then
    echo "O Git está instalado!"
else
    PACKAGE_MANAGER=""
    INSTALL_CMD=""
    CONFIGS=""
    
    function install() {
        eval $CONFIGS
        eval $INSTALL_CMD
    }
    
    if command -v apt >/dev/null; then
        PACKAGE_MANAGER="apt"
        INSTALL_CMD="sudo apt-get install -y git"
        CONFIGS="sudo apt update"
    
    elif command -v dnf >/dev/null; then
        PACKAGE_MANAGER="dnf"
        INSTALL_CMD="sudo dnf install -y git"
        CONFIGS="sudo dnf install -y dnf-plugins-core"
    
    elif command -v yum >/dev/null; then
        PACKAGE_MANAGER="yum"
        INSTALL_CMD="sudo yum install -y git"
        CONFIGS="sudo yum install -y yum-utils"
    
    elif command -v pacman >/dev/null; then
        PACKAGE_MANAGER="pacman"
        INSTALL_CMD="sudo pacman -S --noconfirm git"
        CONFIGS="sudo pacman -Sy"
    
    elif command -v zypper >/dev/null; then
        PACKAGE_MANAGER="zypper"
        INSTALL_CMD="sudo zypper install -y git"
        CONFIGS="sudo zypper refresh"
    
    else
        echo "Gerenciador de pacotes desconhecido!"
        exit 1
    fi
    
    echo "Instalando o Git com o gerenciador de pacotes $PACKAGE_MANAGER"
    install
fi

git clone https://github.com/andradesysadmin/$APP_NAME
cd $APP_NAME/ || exit 1

if command -v docker-compose >/dev/null 2>&1; then
    echo "Docker Compose está instalado!"
else
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.30.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose instalado com sucesso!"
fi

if command -v docker >/dev/null 2>&1; then
    echo "Docker está instalado!"
else
    # instalando o docker em distribuições
    if command -v apt >/dev/null; then
    PACKAGE_MANAGER="apt"
    INSTALL_CMD="sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
    DISTRO_CODENAME=$(lsb_release -c | awk '{print $2}')
    CONFIGS="sudo apt-get update
                sudo apt-get install -y ca-certificates curl
                sudo install -m 0755 -d /etc/apt/keyrings
                sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
                sudo chmod a+r /etc/apt/keyrings/docker.asc
                echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable\" | \
                sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                sudo apt-get update"
    elif command -v dnf >/dev/null; then
        PACKAGE_MANAGER="dnf"
        INSTALL_CMD="sudo dnf install -y docker-ce docker-ce-cli containerd.io"
        CONFIGS="sudo dnf install -y dnf-plugins-core && sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo"
    elif command -v yum >/dev/null; then
        PACKAGE_MANAGER="yum"
        INSTALL_CMD="sudo yum install -y docker-ce docker-ce-cli containerd.io"
        CONFIGS="sudo yum install -y yum-utils && sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo"
    elif command -v pacman >/dev/null; then
        PACKAGE_MANAGER="pacman"
        INSTALL_CMD="sudo pacman -S --noconfirm docker"
        CONFIGS="sudo pacman -Sy"
    elif command -v zypper >/dev/null; then
        PACKAGE_MANAGER="zypper"
        INSTALL_CMD="sudo zypper install -y docker"
        CONFIGS="sudo zypper refresh"
    else
        echo "Gerenciador de pacotes não suportado!"
        exit 1
    fi
    
    if [ $? -ne 0 ]; then

        echo "Docker instalado com sucesso!"

    fi
fi

docker rm -f $APP_NAME || true
docker rmi -f $APP_NAME || true

docker build -t $APP_NAME .
docker run -d -p 8000:8000 --name $APP_NAME $APP_NAME

docker-compose up -d --build
