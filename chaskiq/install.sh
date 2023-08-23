#!/bin/bash

# NOTA: Script exemplo
# Ao selecionar este script durante o deploy de um novo servidor
# o mesmo será executado durante a primeira inicialização.


apt-get update -y

apt-get install ca-certificates curl gnupg -y

install -m 0755 -d /etc/apt/keyringscurl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpgsudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  
  
 apt-get update -y
 
 apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
 
 
 git clone https://github.com/chaskiq/chaskiq.git 
 
 cd chaskiq
 
 echo "127.0.0.1 chat.rafaelb13.cloud" >> /etc/hosts
 
 touch .env
 
echo "HOST=http://chat.rafaelb13.cloud:3000" >> .env
echo "ASSET_HOST=http://chat.rafaelb13.cloud:3000" >> .env
echo "WS=ws://chat.rafaelb13.cloud/cable" >> .env
echo "ADMIN_EMAIL=absam@absam.io" >> .env 
echo "ADMIN_PASSWORD=Absam1042@" >> .env

docker-compose build

docker-compose run rails bundle install

docker-compose run rails yarn install

docker-compose run rails rails db:setup 

docker-compose run rails rails db:create

docker-compose run rails rails db:schema:load

docker-compose run rails rails db:seed

docker-compose run rails rake admin_generator

docker-compose up -d
