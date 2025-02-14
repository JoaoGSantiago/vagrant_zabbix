#!/bin/bash


#update no sistema e instalação zabbix
sudo apt update -y && sudo apt upgrade -y
wget https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.2+ubuntu20.04_all.deb
dpkg -i zabbix-release_latest_7.2+ubuntu20.04_all.deb
apt update

#instalação mysql e proxy do zabbix
apt install -y mysql-server zabbix-proxy-mysql zabbix-sql-scripts zabbix-agent

#configuração do mysql
sudo mysql -e "CREATE DATABASE zabbix CHARACTER SET utf8 COLLATE utf8_bin;"
sudo mysql -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'zabbix_pass';"
sudo mysql -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
sudo mysql -e "set global log_bin_trust_function_creators = 1;"
sudo mysql -e "FLUSH PRIVILEGES;"

#importção do esquema inicial
cat /usr/share/zabbix/sql-scripts/mysql/proxy.sql | sudo mysql -u zabbix -pzabbix_pass zabbix

#configuração do zabbix para o mysql
sudo sed -i "s/# DBPassword=/DBPassword=zabbix_pass/" /etc/zabbix/zabbix_proxy.conf

sudo systemctl restart mysql
sudo systemctl restart zabbix-proxy
sudo systemctl enable zabbix-proxy
sudo systemctl enable mysql zabbix-agent
