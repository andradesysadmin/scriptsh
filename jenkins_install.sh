#!/bin/bash

# verifica se o script foi executado como root
if [ "$(id -u)" -ne 0 ]; then

    echo "O script deve ser executado com privilegios de super usuario!"

fi

# Armazena o gerenciador de pacotes da distro
PACKAGE_MANAGER=""

# Comando de instalação
INSTALL_CMD=""

# Configurações iniciais para a prosseguir com a instalção
CONFIGS=""

# Define a versão do JDK ultilizada
JDK_VERSION="21"

function install() {

    eval $CONFIGS
    eval $INSTALL_CMD

    sudo systemctl start jenkins
    sudo systemctl enable jenkins

    sudo systemctl daemon-reload

}

if command -v apt >/dev/null; then

    PACKAGE_MANAGER="apt"
    INSTALL_CMD="sudo apt update && sudo apt install jenkins -y"
    CONFIGS="sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key && \
             echo \"deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/\" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null"


elif command -v dnf >/dev/null; then

    PACKAGE_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install jenkins -y"
    CONFIGS="sudo wget -O /etc/yum.repos.d/jenkins.repo \
            https://pkg.jenkins.io/redhat-stable/jenkins.repo
            sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
            sudo dnf upgrade
            sudo dnf install fontconfig java-$JDK_VERSION-openjdk"

elif command -v yum >/dev/null; then

    PACKAGE_MANAGER="yum"
    INSTALL_CMD="sudo yum install jenkins -y"
    CONFIGS="sudo yum install java-$JDK_VERSION-openjdk -y"

elif command -v pacman >/dev/null; then

    PACKAGE_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S jenkins -y"
    CONFIGS="sudo pacman -S jre-openjdk -y"

elif command -v zypper >/dev/null; then

    PACKAGE_MANAGER="zypper"
    INSTALL_CMD="sudo zypper install jenkins -y"
    CONFIGS="sudo zypper install java-$JDK_VERSION-openjdk -y"

else

    PACKAGE_MANAGER="Gerenciador de pacotes desconhecido!"
    echo $PACKAGE_MANAGER
    exit 1
fi

echo "Instalando o Jenkins com: $PACKAGE_MANAGER"
install
