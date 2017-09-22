#!/bin/bash

yum -y install epel-release
yum update -y
yum install -y gcc vim net-tools wget zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel net-tools zlib 

echo "[Unit]
After=network.target network-online.target

[Service]
User=root
Type=simple
WorkingDirectory=/storage
ExecStart=/usr/bin/python -m SimpleHTTPServer 8000

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/http-garbage.service 
chmod 664 /etc/systemd/system/http-garbage.service  

mkdir /storage

systemctl stop firewalld
systemctl disable firewalld

systemctl stop selinux
systemctl disable selinux

systemctl daemon-reload
systemctl enable http-garbage.service 
systemctl start http-garbage.service
systemctl status http-garbage.service 

ip a
