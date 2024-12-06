#!/bin/bash

# Script de instalação interativo para pgadmin web e desktop 

sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

sudo sh -c '. /etc/upstream-release/lsb-release && echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$DISTRIB_CODENAME pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

echo "Qual versão deseja instalar?"; read VERSION
echo "pgamin4 = 1"
echo "pgadmin4-desktop = 2"
echo "pgadmin4-web = 3"

if [ $VERSION=1 ]; then

	sudo apt install pgadmin4
fi
if [ $VERSION=2 ]; then

	sudo apt install pgadmin4-desktop

fi
if [ $VERSION=3 ]; then

	sudo apt install pgadmin4-web
	sudo /usr/pgadmin4/bin/setup-web.sh

fi

