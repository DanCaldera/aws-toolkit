#!/bin/bash

sudo apt update

# GIT
sudo apt install git

# nodejs
sudo apt install nodejs
sudo apt install npm

# Install last stable version of nodejs
# install this as root (sudo su)
sudo su
npm cache clean -f
npm install -g n
sudo n stable
# sudo n latest
exit

sudo npm i -g pm2