#!/bin/bash

# Verifica se o script foi executado com os devidos privilégios
if [ "$(id -u)" -ne 0 ]; then
    echo "O script deve ser executado com privilégios de super usuário!"
    exit 1
fi

if command -v git >/dev/null 2>&1; then
    echo "O Git está instalado!"
    exit 1
fi

# Armazena o gerenciador de pacotes da distro
PACKAGE_MANAGER=""

# Comando de instalação
INSTALL_CMD=""

# Configurações iniciais para prosseguir com a instalação
CONFIGS=""

function install() {
    eval $CONFIGS
    eval $INSTALL_CMD
}

# Verifica se o git já está instalado
if command -v git --version > /dev/null; then
    echo "Git já está instalado"
    exit 0
fi

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
    PACKAGE_MANAGER="Gerenciador de pacotes desconhecido!"
    echo $PACKAGE_MANAGER
    exit 1
fi

echo "Instalando o Git com o gerenciador de pacotes $PACKAGE_MANAGER"
install
