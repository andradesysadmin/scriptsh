#!/bin/bash

# Verifica se o script foi executado com os devidos privilégios
if [ "$(id -u)" -ne 0 ]; then
    echo "O script deve ser executado com privilégios de super usuário!"
    exit 1
fi

#Verifica se o Docker está instalado
if command -v docker >/dev/null 2>&1; then
    echo "Docker está instalado!"
    exit 1
fi

PACKAGE_MANAGER=""
INSTALL_CMD=""
CONFIGS=""

function install(){
    eval "$CONFIGS"
    eval "$INSTALL_CMD"

    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
}

if command -v apt >/dev/null; then
    PACKAGE_MANAGER="apt"
    INSTALL_CMD="sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
    DISTRO_CODENAME=$(lsb_release -c | awk '{print $2}')
    
    if [ -f /etc/lsb-release ] && grep -q "Ubuntu" /etc/lsb-release; then
        CONFIGS="sudo apt-get update
                 sudo apt-get install -y ca-certificates curl
                 sudo install -m 0755 -d /etc/apt/keyrings
                 sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
                 sudo chmod a+r /etc/apt/keyrings/docker.asc
                 echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $DISTRO_CODENAME stable\" | \
                 sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                 sudo apt-get update"
    elif [ -f /etc/debian_version ]; then
        CONFIGS="sudo apt-get update
                 sudo apt-get install -y ca-certificates curl
                 sudo install -m 0755 -d /etc/apt/keyrings
                 sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
                 sudo chmod a+r /etc/apt/keyrings/docker.asc
                 echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $DISTRO_CODENAME stable\" | \
                 sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                 sudo apt-get update"
    fi
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

echo "Instalando o Docker com o gerenciador de pacotes $PACKAGE_MANAGER"
install
