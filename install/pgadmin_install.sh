#!/bin/bash

# Script de instalação interativo para pgadmin web e desktop 

sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

# Detecta o codinome da distribuição
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRIB_CODENAME=$VERSION_CODENAME
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    DISTRIB_CODENAME=$DISTRIB_CODENAME
else
    echo "Não foi possível detectar o codinome da distribuição."
    exit 1
fi

sudo sh -c "echo 'deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$DISTRIB_CODENAME pgadmin4 main' > /etc/apt/sources.list.d/pgadmin4.list"
sudo apt update

echo "Qual versão deseja instalar?"
echo "1 - pgAdmin4 (versão desktop)"
echo "2 - pgAdmin4 Desktop"
echo "3 - pgAdmin4 Web"
read VERSION

if [ "$VERSION" -eq 1 ]; then
    sudo apt install pgadmin4
elif [ "$VERSION" -eq 2 ]; then
    sudo apt install pgadmin4-desktop
elif [ "$VERSION" -eq 3 ]; then
    sudo apt install pgadmin4-web
    sudo /usr/pgadmin4/bin/setup-web.sh
else
    echo "Opção inválida!"
    exit 1
fi
