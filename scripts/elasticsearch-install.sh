#!/bin/bash

sudo yum install -y java
# installing from repo
# import GPG key
sudo yum update -y
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
# add repo
sudo tee /etc/yum.repos.d/elasticsearch.repo <<EOF
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
# install elasticsearch
sudo yum install -y elasticsearch
sudo yum clean all
chmod -R 755 /opt/apache-tomcat-8.5.42/logs/

# sudo tee /etc/elasticsearch/elasticsearch.yml <<EOF
# node.name: node-1
# path.data: /var/lib/elasticsearch
# path.logs: /var/log/elasticsearch
# network.host: 172.10.48.5
# http.port: 9200
# luster.initial_master_nodes: node-1
# EOF

sudo tee /etc/elasticsearch/elasticsearch.yml <<EOF
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 172.10.48.5
discovery.type: single-node
EOF

# enable & ran service
sudo systemctl start elasticsearch.service
sudo systemctl enable elasticsearch.service
