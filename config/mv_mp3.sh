#!/bin/bash

# Script que pega todos os mp3 baixados e os transfere para a pasta apropriada

find /home/gabriel/Downloads/ -name '*.mp3' > mp3.txt
for i in $(cat mp3.txt); do
    echo "Movendo $i para /home/gabriel/Musicas/"
    mv $i /home/gabriel/Musicas/;
done
rm mp3.txt
