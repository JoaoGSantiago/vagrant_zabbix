#!/bin/bash
set -e

#atualização e instalação
sudo apt update -y && sudo apt upgrade -y

sudo apt install -y mysql-server

sudo systemctl enable mysql
sudo systemctl start mysql

curl -O https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu20.04_all.deb
sudo apt install -y ./zabbix-release_6.0-4+ubuntu20.04_all.deb
sudo apt update -y
sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent

#configuração database e zabbix
sudo mysql -e "CREATE DATABASE zabbix CHARACTER SET utf8 COLLATE utf8_bin;"
sudo mysql -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'teste123';"
sudo mysql -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | sudo mysql -u zabbix -pteste123 zabbix

sudo sed -i 's/# DBPassword=/DBPassword=teste123/' /etc/zabbix/zabbix_server.conf

#iniciando serviço
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2

